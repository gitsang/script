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

<html lang="ch">
    <head>
        <meta name="viewport" charset="UTF-8" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <title>Timestamp</title>
        <link rel="icon"  href="favicon.ico" type="image/x-icon">
    </head>
    <body>
        <div class="center">
            <div class="box">
                <form action="<?php $_PHP_SELF ?>" method="post">
                    <h4>time_zone: <?php echo date_default_timezone_get(); ?><br></h4>
                </form>
            </div>
        </div>
        <div class="center">
            <div class="box">
                <form action="<?php $_PHP_SELF ?>" method="post">
                    <h4>ts&nbsp;: <input type="text" name="ts" value="<?php if(isset($_POST['ts'])) { echo $_POST['ts']; } else { echo getMillisecond(); } ?>"> <input type="submit" value="convert"></h4>
                    <h4>tm&nbsp;: <?php if(isset($_POST['ts'])) { echo ts_to_date($_POST["ts"]); } else { echo ts_to_date(getMillisecond()); } ?></h4>
                </form>
            </div>
        </div>
        <div class="center">
            <div class="box">
                <form action="<?php $_PHP_SELF ?>" method="post">
                    <h4>tm&nbsp;: <input type="text" name="date" value="<?php if(isset($_POST['date'])) { echo $_POST['date']; } else { echo ts_to_date(getMillisecond()); } ?>"> <input type="submit" value="convert"></h4>
                    <h4>ts&nbsp;: <?php if(isset($_POST['date'])) { echo date_to_ts($_POST["date"]); } else { echo date_to_ts(ts_to_date(getMillisecond())); } ?></h4>
                </form>
            </div>
        </div>
    </body>
</html>

<style>
    body{
        margin-top: 40px;
    }
    h4{
        color: #3273dc;
    }
    h5{
        color: #808080;
    }
    a{
        text-decoration: none;
    }
    .center{
        display: -webkit-flex;  
        -webkit-justify-content: center;  
        -webkit-align-items: center;  
    }
    .box{
        border-radius: 4px;
        width: 300px;
        height: 112px;
        padding: 0px 30px 0px 30px;
        background-color: #fff;
        border-radius: 4px;
        border: 1px solid #e4ecf3;
        margin: 20px 0 0 0;
        -webkit-transition: all 0.3s ease;
        -moz-transition: all 0.3s ease;
        -o-transition: all 0.3s ease;
        transition: all 0.3s ease;
    }
</style>
