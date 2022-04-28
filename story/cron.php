<?php
date_default_timezone_set('UTC');
require_once 'class.instagram.php';
require_once 'firestore.php';
$mindate = date("Y-m-d H:i:s"); 
$maxdate = date("Y-m-d H:i:s",strtotime('+1 hours'));
$story = new Firestore('Students');
$data = $story->getWhere('isExpire', $mindate , $maxdate); 
if(count($data) > 0){
    foreach($data as $user){
        $details = new instagram_story();
        $key = array_search(false, array_column($user['promos'], 'isClaimed'));
        $details->updateStory($user['userId'], $user['email'], $user['promos'][$key]['businessID']);
    }
} 