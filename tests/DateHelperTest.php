<?php

use PHPUnit\Framework\TestCase;
use App\DateHelper;

class DateHelperTest extends TestCase
{
    public function testReadableDate()
    {
        $date = '2025-04-19';
        $formatted = DateHelper::readableDate($date);

        $this->assertStringContainsString('April', $formatted);
        $this->assertStringContainsString('2025', $formatted);
    }

    public function testDaysBetween()
    {
        $start = '2025-04-01';
        $end = '2025-04-19';

        $this->assertEquals(18, DateHelper::daysBetween($start, $end));
    }
}
