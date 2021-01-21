<?php
    function ts_to_date($time) {
        if (strlen($time) == 10) {
            return date("Y-m-d H:i:s", $time);
        } else if (strlen($time) == 13) {
            $sec = $time / 1000;
            $usec = $time % 1000;
            $date = date("Y-m-d H:i:s.x", $sec);
            return str_replace('x', $usec, $date);
        } else {
            $len = strlen((string)$time);
            $subtime = $time / pow(10, $len - 13);
            $sec = $subtime / 1000;
            $usec = $subtime % 1000;
            $date = date("Y-m-d H:i:s.x", $sec);
            return str_replace('x', $usec, $date);
        }
    }

    function getMillisecond() {
        list($msec, $sec) = explode(' ', microtime());
        $msectime = (float)sprintf('%.0f', (floatval($msec) + floatval($sec)) * 1000);
        return $msectimes = substr($msectime, 0, 13);
    }

    function date_to_ts($date) {
        list($date_s, $date_ms) = explode(".", $date);
        $ts_s = strtotime($date_s);
        $ts_ms= str_pad($ts_s.$date_ms, 13, "0", STR_PAD_RIGHT);
        return $ts_ms;
    }
?>

<html>
    <head>
        <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>timestamp</title>
    </head>
    <link rel="icon"  href="favicon.ico" type="image/x-icon">
    <style>
        .main{
            text-align: left;
            background-color: #fff;
            border-radius: 20px;
            width: 400px;
            height: 100px;
            margin: auto;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            font-size:18px;
            font-family:monospace;
        }
    </style>
    <body>
        <div class="main">
            <form action="<?php $_PHP_SELF ?>" method="post">
                ts&nbsp;: <input type="text" name="ts" value="<?php if(isset($_POST['ts'])) { echo $_POST['ts']; } else { echo getMillisecond(); } ?>"> <input type="submit" value="convert"><br>
                date: <?php if(isset($_POST['ts'])) { echo ts_to_date($_POST["ts"]); } else { echo ts_to_date(getMillisecond()); } ?><br>
                <br>
                date: <input type="text" name="date" value="<?php if(isset($_POST['date'])) { echo $_POST['date']; } else { echo ts_to_date(getMillisecond()); } ?>"> <input type="submit" value="convert"><br>
                ts&nbsp;: <?php if(isset($_POST['date'])) { echo date_to_ts($_POST["date"]); } else { echo date_to_ts(ts_to_date(getMillisecond())); } ?><br>
            </form>
        </div>
        <!--
        -->
    </body>
</html>

