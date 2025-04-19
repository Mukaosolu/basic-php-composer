<?php

namespace App;

use Carbon\Carbon;

class DateHelper
{
    /**
     * Get a human-readable date string like "Monday, April 15, 2024"
     */
    public static function readableDate(string $date): string
    {
        return Carbon::parse($date)->translatedFormat('l, F j, Y');
    }

    /**
     * Get difference in days between two dates
     */
    public static function daysBetween(string $start, string $end): int
    {
        $startDate = Carbon::parse($start);
        $endDate = Carbon::parse($end);
        return $startDate->diffInDays($endDate);
    }
}
