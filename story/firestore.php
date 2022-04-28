<?php

require_once __DIR__.'/vendor/autoload.php';

use Google\Cloud\Firestore\FirestoreClient;

class Firestore{
    protected $db;
    protected $name;

    public function __construct($collections){
        $url = __DIR__.'/config/sway-fe5b0-firebase-adminsdk-1g09w-e82043015d.json';
        $this->db = new FirestoreClient([
            'projectId' => 'sway-fe5b0',
            'keyFilePath' => $url
        ]);

        $this->name = $collections;
    }

    public function getDocument($name){ 
        try{
            $data = $this->db->collection($this->name)->document($name)->snapshot()->data();
            return $data;
        }catch(Exception $exception){
            return 'error';
        }    
    }

    public function getWhere($field, $minvalue, $maxvalue){
        $arr = [];
        $query = $this->db->collection($this->name)->where($field, '>', $minvalue)->where($field, '<', $maxvalue)->documents()->rows();
        if(!empty($query)){
            foreach($query as $item){
                $arr[] = $item->data();
            }
        }
        return $arr;
    }

    public function newDocument($name,$data = []){
        try{
            $result = $this->db->collection($this->name)->document($name)->create($data);
            return $result;
        }catch(Exception $ex){
            return 'Error';
        }
    }

    public function updateDocument($name, $data){
        try{
            $result = $this->db->collection($this->name)->document($name);
            $result->update($data);
            return $result;
        }catch(Exception $ex){
            return $ex;
        }
    }

    public function updateExistingDocument($name){
        try{
            $result = $this->db->collection($this->name)->document($name)->reference().child('promos.0').child('storyCount').setValue(10);
            return $result;
        }catch(Exception $ex){
            return $ex;
        }
    }
}