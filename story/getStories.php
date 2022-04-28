<?php
require_once 'class.instagram.php';
date_default_timezone_set('UTC');
if (isset($_POST['userId']) && isset($_POST['coockies']) && isset($_POST['email']) && isset($_POST['businessId'])){
	$userId = $_POST['userId'];
	$coockies = $_POST['coockies'];
	$user = $_POST['email'];
	$businessId = $_POST['businessId'];
	$filename = "cookies/$userId.txt";
	if(file_put_contents($filename, base64_decode($coockies)))
	{
		$story = new instagram_story();
		$data = $story->getStory($userId, $user, $businessId);
		print $data;
	}
}else{
    print json_encode(['error' => 'error']);
}
?>

