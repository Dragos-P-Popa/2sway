//
//  DatabaseManager.swift
//  2Sway
//
//  Created by Joe Feest on 21/09/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    ///Instance of Firebase Firestore.
    let db = Firestore.firestore()
    ///Instance of Firestore Storage.
    let storage = Storage.storage().reference()
    
    /**
     Upload user's details to database.
     
     - parameter user: UserModel which holds current users details.
     */
    func uploadUser(user: UserModel) {
        print("uploading user")
        
        guard let name = user.name else {
            print("No name")
            return
        }
        guard let urlString = user.urlString else {
            print("No URL")
            return
        }
        
       guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found1")
            return
        }
        do {
            try db.collection(K.Database.collections.students).document(email).setData(from: user) { error in
                if let e = error {
                    print("Issue saving data: \(e)")
                } else {
                    
                    print("Successfully saved data")
                }
            }
        } catch(let error) {
            print("Catch error", error)
        }
    }
    
    /**
     Gets current users' Firesore data.  Uses Firebase Auth to get the current users' email address. Using this it fetched the users record from the Firestore "Students" collection.
     
     - returns: UserModel of fetched user.
     
     # Notes: #
     1. Uses Firebase Auth to get the current users' email address. Using this it fetched the users record from the Firestore "Students" collection.
     */
    func getUser(completion: @escaping(Bool) -> Void) {
        db.collection("Students").getDocuments() { documents, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            } else {
                do{
                    for document in documents!.documents {
                        if document.documentID == FirebaseAuth.Auth.auth().currentUser?.email?.localizedLowercase {
                            print(FirebaseAuth.Auth.auth().currentUser?.email?.localizedLowercase)
                            print("Firebase data ", document.data())
                            let data = try JSONSerialization.data(withJSONObject: document.data(), options: .prettyPrinted)
                            print("Hello user ", document.data())
                            //let user = try? JSONDecoder().decode(UserModel.self, from: data)
                            let dataDescription = document.data()
                            var strProfileUrl = ""
                            var accountStatus = 0
                            var strname = ""
                            var strEmail = ""
                            var strInsta = ""
                            var isExpire = ""
                            var IntTotleng = 0
                            var tier = 0
                            var aryStoryIds = [String]()
                            var aryStoryIds1 = [String]()
                            var aryPromoMain = [StudentPromos]()
                            if let dictMain = dataDescription as? NSDictionary {
                                if let status = dictMain.object(forKey:"accountStatus") as? Int {
                                    accountStatus = status
                                }
                                if let proPic = dictMain.object(forKey:"urlString") {
                                    strProfileUrl = "\(proPic)"
                                }

                                if let email = dictMain.object(forKey:"email") {
                                    strEmail = "\(email)"
                                }
                                if let isExpireMain = dictMain.object(forKey:"isExpire") {
                                    isExpire = "\(isExpireMain)"
                                } else {
                                    isExpire = ""
                                }
                                if let name = dictMain.object(forKey:"name") {
                                    strname = "\(name)"
                                }
                                if let instagram = dictMain.object(forKey:"instagram") {
                                    strInsta = "\(instagram)"
                                }
                                if let totalEngagements = dictMain.object(forKey:"totalEngagements") as? Int {
                                    IntTotleng = totalEngagements
                                }
                                if let storyID = dictMain.object(forKey:"storyID") as? NSMutableArray {
                                   print(storyID)
                                }
                                if let currentTier = dictMain.object(forKey: "tier") as? Int {
                                    tier = currentTier
                                }
                                if let storyIds = dictMain.object(forKey:"storyIds") as? [String] {
                                    for i in storyIds {
                                        aryStoryIds.append(i)
                                    }
                                }
                                if let promos = dictMain.object(forKey:"promos") as? NSArray {
                                        for i in 0..<promos.count {
                                            if let mainPromos = promos.object(at:i) as? NSDictionary {
                                                if let storyIds = mainPromos.object(forKey:"storyID") as? [String] {
                                                    for i in storyIds {
                                                        aryStoryIds1.append(i)
                                                    }
                                                }
                                                if let storyIds = mainPromos.object(forKey:"storyID") as? String {
                                                    aryStoryIds1.append(storyIds)
                                                }
                                                if let mainPromos = promos.object(at:i) as? NSDictionary {
                                                    let claimedPromo = StudentPromos(businessID:mainPromos.object(forKey:"businessID") as! String, promoName:mainPromos.object(forKey:"businessID") as! String, discount:mainPromos.object(forKey:"discount") as? Int ?? 0, isClaimed:mainPromos.object(forKey:"isClaimed") as? Bool ?? false, storyID:aryStoryIds1, storyCount:mainPromos.object(forKey:"storyCount") as? Int ?? 0, totalEngagements:mainPromos.object(forKey:"totalEngagements") as? Int ?? 0)
                                                    aryPromoMain.append(claimedPromo)
                                                }
                                            }
                                        }
                                    print(aryPromoMain)
                                    AppData.shared.user = UserModel(accountStatus:accountStatus, email:strEmail, name:strname, isExpire:isExpire, urlString:strProfileUrl, dataThisMonth:DataThisMonth(), tier: tier, totalEngagements:IntTotleng, promos:aryPromoMain, instagram:strInsta, storyIds:aryStoryIds)
                            }
                            //AppData.shared.user = user
                            completion(true)
                            }
                        }
                    }
                }catch{
                    print("User error ", error)
                    completion(false)
                }
            }
        }
    }
    
    /**
     Updates business record in Firebase Firestore.
     
     - parameter business: BusinessModel.
     
     */
    func updateBusiness(businessID: String, business: Business) {
        do {
            try db.collection("Businesses").document(businessID).setData(from: business)
        } catch {
            print("Couldn't update business", error.localizedDescription)
        }
    }
    
    
    ///Updates local claimed promos.
    func uploadLocalClaimedPromos() {
        
        var promos: [ClaimedPromo] = []
        for promo in ActiveUser.activeUser.myPromos {
            if let p = promo {
                promos.append(p)
            }
        }
        self.uploadClaimedPromos(with: promos)
    }
    
    /**
     Updates promos. Syncs local promos with Firebase Firestore stored promos.
     
     - parameter claimedPromos: ClaimedPromo.
     */
    func uploadClaimedPromos(with claimedPromos: [ClaimedPromo]) {
        print("Synchronising")
        guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found2")
            return
        }
        
        // Delete all claimedPromo entries before re-entering
        getClaimedPromoCount { count in
            guard let firebaseCount = count else {return}
            let localCount = ActiveUser.activeUser.myPromos.count
            
            if firebaseCount == 0 {
                for i in 0 ..< localCount {
                    
                    guard let promo = ActiveUser.activeUser.myPromos[i] else {
                        print("Can't get claimedPromo object")
                        return
                    }
                    
                    if let timeRedeemed = promo.timeRedeemed {
                        
                        let codableClaimedPromo = CodableClaimedPromo(promoID: promo.promoID, brandID: promo.brandID, timeClaimed: promo.timeClaimed, isRedeemed: promo.isRedeemed, timeRedeemed: timeRedeemed, percentageOff: promo.percentageOff, discountCode: promo.discountCode)
                        
                        do {
                            try self.db.collection(email).document("claimedPromo\(i)").setData(from: codableClaimedPromo)
                        } catch let error {
                            print("Error writing promo to firestore: \(error)")
                        }
                    } else {
                        let codableClaimedPromo = CodableClaimedPromo(promoID: promo.promoID, brandID: promo.brandID, timeClaimed: promo.timeClaimed, percentageOff: promo.percentageOff, discountCode: promo.discountCode)
                        
                        do {
                            try self.db.collection(email).document("claimedPromo\(i)").setData(from: codableClaimedPromo)
                        } catch let error {
                            print("Error writing promo to firestore: \(error)")
                        }
                    }
                }
            }
            
            for i in 0 ..< firebaseCount {
                self.db.collection(email).document("claimedPromo\(i)").delete { error in
                    if let e = error {
                        print("Error deleting docs: \(e)")
                    } else {
                        // Only rewrite once delete loop is on its final iteration
                        if i == firebaseCount - 1 {
                            for i in 0 ..< localCount {
                                
                                guard let promo = ActiveUser.activeUser.myPromos[i] else {
                                    print("Can't get claimedPromo object")
                                    return
                                }
                                
                                if let timeRedeemed = promo.timeRedeemed {
                                    let codableClaimedPromo = CodableClaimedPromo(promoID: promo.promoID, brandID: promo.brandID, timeClaimed: promo.timeClaimed, isRedeemed: promo.isRedeemed, timeRedeemed: timeRedeemed, percentageOff: promo.percentageOff, discountCode: promo.discountCode)
                                    do {
                                        try self.db.collection(email).document("claimedPromo\(i)").setData(from: codableClaimedPromo)
                                    } catch let error {
                                        print("Error writing promo to firestore: \(error)")
                                    }
                                } else {
                                    let codableClaimedPromo = CodableClaimedPromo(promoID: promo.promoID, brandID: promo.brandID, timeClaimed: promo.timeClaimed, percentageOff: promo.percentageOff, discountCode: promo.discountCode)
                                    
                                    do {
                                        try self.db.collection(email).document("claimedPromo\(i)").setData(from: codableClaimedPromo)
                                    } catch let error {
                                        print("Error writing promo to firestore: \(error)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     Removes a claimed promo from Firebase Firestore.
     
     - parameter id: Promo ID as String.
     */
    func removeClaimedPromo(with id: String) {
        guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found2.1")
            return
        }
        getClaimedPromoCount { count in
            guard let count = count else {return}
            for i in 0..<count {
                let docRef = self.db.collection(email).document("claimedPromo\(i)")
                docRef.getDocument { document, error in
                    
                    let result = Result {
                        try document?.data(as: CodableClaimedPromo.self)
                    }
                    switch result {
                    case .success(let codableClaimedPromo):
                        if let codableClaimedPromo = codableClaimedPromo {
                            // A `codableClaimedPromo` value was successfully initialized from the DocumentSnapshot.
                            if codableClaimedPromo.promoID == id {
                                // delete data and then break out of for loop
                                docRef.delete()
                                print("\(id) deleted")
                                break
                            }
                            
                        } else {
                            // a nil value was successfully initialised from the snapshot
                            // or the snapshot was nil
                            print("ClaimedPromo Document doesn't Exist: \(docRef.documentID)")
                        }
                    case .failure(let error):
                        // A CodableClaimedPromo could not be initialised from the snapshot
                        print("Error decoding city: \(error)")
                    }
                }
            }
        }
        
    }
    
    func getClaimedPromoCount(countCompletion: @escaping (Int?) -> Void) {
        
        var claimedPromoCount = 0

        guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found3")
            return
        }
        
        db.collection(email).getDocuments( completion: {
            querySnapshot, error in
            if let e = error {
                print("Error retreiving claimedPromo data fron Firestore: \(e)")
                return
            } else {
                guard let snapshot = querySnapshot else {return}
                
                for doc in snapshot.documents {
                    if doc.documentID.contains("claimedPromo") {
                        claimedPromoCount += 1
                    }
                }
                countCompletion(claimedPromoCount)
            }
        })
    }
    
    func updateLocalClaimedPromos(completion: @escaping (_ success: Bool) -> Void) {
                
        ActiveUser.activeUser.clearLocalPromos()
        
        getClaimedPromoCount { claimedPromoCount in
            
            guard let claimedPromoCount = claimedPromoCount else {
                print("Could not get claimedPromoCount")
                return
            }
            
            guard let email = Auth.auth().currentUser?.email else {
                print("User ID could not be found4")
                return
            }
            
            for i in 0 ..< claimedPromoCount {
                
                print("attempting to update local promo \(i)")
                
                let docRef = self.db.collection(email).document("claimedPromo\(i)")
                docRef.getDocument { document, error in
                    
                    let result = Result {
                        try document?.data(as: CodableClaimedPromo.self)
                    }
                    switch result {
                    case .success(let codableClaimedPromo):
                        if let codableClaimedPromo = codableClaimedPromo {
                            // A `codableClaimedPromo` value was successfully initialized from the DocumentSnapshot.
                            
                           // let claimedPromo = codableClaimedPromo.createClaimedPromo()
                            //ActiveUser.activeUser.myPromos.append(claimedPromo)
                            
                        } else {
                            // a nil value was successfully initialised from the snapshot
                            // or the snapshot was nil
                            print("Document doesn't Exist")
                        }
                    case .failure(let error):
                        // A CodableClaimedPromo could not be initialised from the snapshot
                        print("Error decoding city: \(error)")
                        completion(false)
                    }
                }
            }
            completion(true)
        }
    }
    
    func updateLocalDetails() {
                
        // Set local ActiveUser's profile pic to cloud stored version
        guard let email = Auth.auth().currentUser?.email else {
            print("User ID could not be found5")
            return
        }
        ActiveUser.activeUser.email = email
        
        let docRef = db.collection("Students").document(email).collection("promos").document(email)
        docRef.getDocument { document, error in
            
            if let e = error {
                print("Error retreiving data fron Firestore: \(e)")
            } else {
                if let document = document, document.exists {
                    
                    print("Trying to set local details")
                    
                    guard let data = document.data() else {
                        print("Error converting user details document to data")
                        return
                    }
                    
                    guard let imageURL = data[K.Database.details.url] as? String, let url = URL(string: imageURL) else {
                        print("imageURL is nil")
                        return
                    }
                    ActiveUser.activeUser.urlString = imageURL
                    
                    self.retrieveImage(url: url)
                    
                    guard let name = data[K.Database.details.name] as? String else {
                        print("Name is nil")
                        return
                    }
                    ActiveUser.activeUser.name = name
                    
                    guard let totalPromosDone = data[K.Database.details.totalPromos] as? Int else {
                        print("Total promos is nil")
                        return
                    }
                    ActiveUser.activeUser.totalPromosDone = totalPromosDone
                }
            }
        }
    }
    
    func retrieveImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("error retreiving image")
                return
            }
            
            let image = UIImage(data: data)
            ActiveUser.activeUser.profilePhoto = image
            print("Image set")
        }.resume()
    }
    
    // Uploads data to storage
    func uploadImageData(data: Data) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error retrieving current user")
            return
        }
        storage.child("ProfilePics/\(userID).jpeg").putData(data, metadata: nil) { _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            
            self.storage.child("ProfilePics/\(userID).jpeg").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    print("Error in downloading url")
                    return
                }
                
                let urlString = url.absoluteString
                AppData.shared.user?.urlString = urlString
                self.uploadUser(user: AppData.shared.user!)
                self.getUser(completion: { success in })
                print("upload complete")
                NotificationCenter.default.post(name: Notification.Name("NotificationProgress"), object: nil, userInfo:nil)
            })
        }
    }
    
    
    // submit feedback
    func submitFeedback(feedback: Feedback, completion: @escaping(Bool) -> Void) {
        do {
            try db.collection("Feedback").document().setData(from: feedback)
            completion(true)
        } catch(let error) {
            print(error.localizedDescription)
            completion(false)
        }
    }
}

