<?php
require_once 'firestore.php';
date_default_timezone_set('UTC');
use Google\Cloud\Firestore\FieldValue;
class instagram_story
{
    protected function file_get_contents_curl($user_id, $url)
    {
        $cookies = dirname(__FILE__)."/cookies/$user_id.txt" ;
        $curl = curl_init();
        curl_setopt ($curl, CURLOPT_URL, $url);
        curl_setopt ($curl, CURLOPT_FOLLOWLOCATION, 1);
        curl_setopt ($curl, CURLOPT_COOKIEFILE, $cookies);
        curl_setopt ($curl, CURLOPT_RETURNTRANSFER, true);
        $answer = curl_exec($curl);
        curl_close($curl);
        return $answer;
    }
    
    public function getStory($userId, $user, $businessId)
    {
        $stories =  $this->file_get_contents_curl($userId, "https://www.instagram.com/graphql/query/?query_hash=de8017ee0a7c9c45ec4260733d81ea31&variables=%7B%22reel_ids%22%3A%5B%22$userId%22%5D%2C%22tag_names%22%3A%5B%5D%2C%22location_ids%22%3A%5B%5D%2C%22highlight_reel_ids%22%3A%5B%5D%2C%22precomposed_overlay%22%3Afalse%2C%22show_story_viewer_list%22%3Atrue%2C%22story_viewer_fetch_count%22%3A50%2C%22story_viewer_cursor%22%3A%22%22%7D");
        $data = json_decode($stories, true); 
        $isuser = new Firestore('Students');
		$userdetails = $isuser->getDocument($user);
		if($userdetails){
			if(isset($userdetails['isExpire']) && $userdetails['isExpire'] && $userdetails['isExpire'] < date("Y-m-d H:i:s")){
				return json_encode(['msg' => 'Your story has expired and it did not reach the required story views to claim the lowest discount. You must cancel this promotion before you can do another one.']);
			}elseif(count($userdetails['promos']) > 0 && array_search(false, array_column($userdetails['promos'], 'isClaimed')) !== false){
				return json_encode(['msg' => 'You already have an active promotion. You must cancel this promotion before you can do another one.']);
			}elseif(count($data['data']['reels_media']) > 0){
				if(array_search($businessId, array_column($userdetails['promos'], 'businessID')) !== false){
					return json_encode(['msg' => 'You already have a claimed discount at this business '. $businessId.' You must redeem this discount before you can promote this business again']);
				}
				$business = new Firestore('Businesses');
				$businessdata = $business->getDocument($businessId);
				$oldId = count($userdetails['storyIds']) > 0 ? $userdetails['storyIds'] : [];
				$reels_media = $data['data']['reels_media'][0]; 
				$count = 0;
				$id = "";
				$expiry = "";
				foreach($reels_media['items'] as $item){
					if(count($item['tappable_objects']) > 0){
						if($item['tappable_objects'][0]['__typename'] === 'GraphTappableLocation' && !in_array($item['id'], $oldId) && in_array($item['tappable_objects'][0]['id'], $businessdata['locationId'])){
							$count = $item['story_view_count'];
							$id = $item['id'];
							$expiry = $item['expiring_at_timestamp'];
						}	
					}
				}
				$discount = 0;
				$index = ""; 
				if(isset($businessdata['promos']) && count($businessdata['promos']) > 0){
					foreach($businessdata['promos'] as $promo){
						if($count >= $promo['highestView']){
							$discount = $promo['highestDiscount'];
							$index = $promo['name'];
						}elseif($count >= $promo['middleView']){
							$discount = $promo['middleDiscount'];
							$index = $promo['name'];
						}elseif($count >= $promo['lowestView']){
							$discount = $promo['lowestDiscount'];
							$index = $promo['name'];
						}
					}
				}
				if($count > 0){
					$totalCount = $businessdata['totalEngagements'] + $count;
					$updateBusinessData = [];
					$updateBusinessData[] = ['path' => 'totalEngagements', 'value' =>$totalCount ];
					$business->updateDocument($businessId,$updateBusinessData);
				}
				if($id != ""){
					$storyId = $userdetails['storyIds'];
					$storyId[] = $id;  
					$fs = new Firestore('Students');
					$updatedata = [];
					$updatedata[] = [ 'path' => 'instagram', 'value' => $reels_media['owner']['username']];
					$updatedata[] =	['path' => 'userId', 'value' =>$userId];
					$updatedata[] =	['path' => 'totalEngagements', 'value' =>$userdetails['totalEngagements'] + $count];
					$updatedata[] =	['path' => 'isExpire' , 'value' => date("Y-m-d H:i:s",$expiry)];
					$updatedata[] =	['path' => 'promos', 'value' => FieldValue::arrayUnion(array(array('businessID' => $businessId, 'discount' => $discount, 'isClaimed' => false, 'promoIndex' => $index, 'storyCount' => $count,'storyID' => [$id],'totalEngagements' => $count)))];
					$updatedata[] =	['path' => 'storyIds', 'value' => $storyId];
					$submit = $fs->updateDocument($user,$updatedata);
					if($submit){
						$data['data']['count'] = $count;
						$data['data']['discount'] = $discount;
						$data['data']['storyID'] = [$id];
						$data['msg'] = 'success';
						return json_encode($data);
					}else{
						return json_encode(['msg' => 'Error']);
					}
				}else{
					return json_encode(['msg' => 'You have not posted a story that includes the location tag of the venue']);
				}
			}else{
				return json_encode(['msg' => 'You have not posted a story that includes the location tag of the venue']);
			}
		}else{
			return json_encode(['msg' => 'User not found']);
		}
	}
	

	public function updateStory($userId, $user, $businessId){
		$stories =  $this->file_get_contents_curl($userId, "https://www.instagram.com/graphql/query/?query_hash=de8017ee0a7c9c45ec4260733d81ea31&variables=%7B%22reel_ids%22%3A%5B%22$userId%22%5D%2C%22tag_names%22%3A%5B%5D%2C%22location_ids%22%3A%5B%5D%2C%22highlight_reel_ids%22%3A%5B%5D%2C%22precomposed_overlay%22%3Afalse%2C%22show_story_viewer_list%22%3Atrue%2C%22story_viewer_fetch_count%22%3A50%2C%22story_viewer_cursor%22%3A%22%22%7D");
        $data = json_decode($stories, true); 
        $isuser = new Firestore('Students');
		$userdetails = $isuser->getDocument($user);
		if($userdetails){ 
			$promoId = array_search($businessId, array_column($userdetails['promos'], 'businessID'));
			if(count($data['data']['reels_media']) > 0){
				$oldId = count($userdetails['promos']) > 0 ? $userdetails['promos'][$promoId]['storyID'] : [];
				$reels_media = $data['data']['reels_media'][0]; 
				$old_count = $userdetails['promos'][$promoId]['storyCount'];
				$count = 0;
				$id = "";
				foreach($reels_media['items'] as $item){
					if(count($item['tappable_objects']) > 0){
						if($item['tappable_objects'][0]['__typename'] === 'GraphTappableLocation' && in_array($item['id'], $oldId)){
							$userdetails['promos'][$promoId]['storyCount'] = $item['story_view_count']; 
							$userdetails['promos'][$promoId]['totalEngagements'] = $item['story_view_count'];
							$count = $item['story_view_count'];
							$id = $item['id'];
						}	
					}
				}
			}
			$business = new Firestore('Businesses');
			$businessdata = $business->getDocument($businessId);
			if(isset($businessdata['promos']) && count($businessdata['promos']) > 0){
				foreach($businessdata['promos'] as $promo){
					if($count >= $promo['highestView']){
						$userdetails['promos'][$promoId]['discount'] = $promo['highestDiscount'];
						$userdetails['promos'][$promoId]['promoIndex'] = $promo['name']; 
					}elseif($count >= $promo['middleView']){
						$userdetails['promos'][$promoId]['discount'] = $promo['middleDiscount'];
						$userdetails['promos'][$promoId]['promoIndex'] = $promo['name'];
					}elseif($count >= $promo['lowestView']){
						$userdetails['promos'][$promoId]['discount'] = $promo['lowestDiscount'];
						$userdetails['promos'][$promoId]['promoIndex'] = $promo['name'];
					}
				}
			}
			if($count - $userdetails['promos'][$promoId]['storyCount']  > 0){
				$totalCount = $businessdata['totalEngagements'] + ($count - $userdetails['promos'][$promoId]['storyCount']);
				$updateBusinessData = [];
				$updateBusinessData[] = ['path' => 'totalEngagements', 'value' =>$totalCount ];
				$business->updateDocument($businessId,$updateBusinessData);
			}
			if($id != ""){
				$fs = new Firestore('Students');
				$updatedata = [];
				$updatedata[] =	['path' => 'promos', 'value' => $userdetails['promos']];
				$updatedata[] =	['path' => 'totalEngagements', 'value' => $userdetails['totalEngagements'] + ($count - $old_count)];
				$submit = $fs->updateDocument($user,$updatedata);
				if($submit){
					$data['data']['count'] = $userdetails['promos'][$promoId]['storyCount'];
					$data['data']['discount'] = $userdetails['promos'][$promoId]['discount'];
					$data['data']['storyID'] = [$id];
					$data['msg'] = 'success';
					return json_encode($data);
				}else{
					return json_encode(['msg' => 'Error']);
				}
			}else{
				if(isset($userdetails['isExpire']) && $userdetails['isExpire'] && $userdetails['isExpire'] < date("Y-m-d H:i:s") && $discount == 0){
					return json_encode(['msg' => 'Your story has expired and it did not reach the required story views to claim the lowest discount. You must cancel this promotion before you can do another one.']);
				}else{
					$data['data']['reels_media'] = [];
					$data['data']['count'] = $userdetails['promos'][$promoId]['storyCount'];
					$data['data']['discount'] = $userdetails['promos'][$promoId]['discount'];
					$data['data']['storyID'] = $userdetails['promos'][$promoId]['storyID'];
					$data['msg'] = 'success';
					return json_encode($data);
				}
			}
		}else{
			return json_encode(['msg' => 'User not found']);
		}
	}
}
