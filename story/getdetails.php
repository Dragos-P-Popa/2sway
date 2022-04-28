<?php
require_once 'firestore.php';
$isuser = new Firestore('Students');
$userdetails = $isuser->getDocument('kaivan.desai@techcronus.com');
print json_encode($userdetails);