<?php

require __DIR__ . '/../vendor/autoload.php';
use Carbon\Carbon;

// Default timezone
$timezone = $_GET['zone'] ?? 'UTC';

try {
    $now = Carbon::now($timezone);
    $tomorrow = Carbon::tomorrow($timezone);
} catch (Exception $e) {
    http_response_code(400);
    echo "Invalid timezone.";
    exit;
}

printf("Right now in %s is %s.\n", $timezone, $now->format('Y-m-d g:i:s A'));
printf("Tomorrow in %s will be %s.\n", $timezone, $tomorrow->format('Y-m-d'));
