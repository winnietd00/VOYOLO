<?php 

class Alerts {

    public static function setAlert($message, $type="warning") {
        $_SESSION['alert']['message'] = $message;
        $_SESSION['alert']['type'] = $type;
    }

    public static function getAlert() {
        if (isset($_SESSION['alert'])) {
            extract($_SESSION['alert']);
            unset($_SESSION['alert']);
            $html = "<div class='container mt-5 mb-5'>";
            $html .= "<div class='row d-flex justify-content-center'>";
            $html .= "<div class='col-auto'>";
            $html .= "<div class='alert alert-{$type}' role='alert'>";
            $html .= "<strong>{$message}</strong>";
            $html .= "</div>";
            $html .= "</div>";
            $html .= "</div>";
            $html .= "</div>";
            return $html;
        }
    }

}

?>