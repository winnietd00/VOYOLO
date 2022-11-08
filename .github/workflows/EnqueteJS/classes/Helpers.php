<?php

class Helpers {

    public function card_header($mt, $bg, $color, $balise, $text) {
        $html = "<div class='container mt-{$mt}'>";
        $html .= "<div class='row d-flex justify-content-center'>";
        $html .= "<div class='col-auto'>";
        $html .= "<div class='card'>";
        $html .= "<div class='card-header bg-{$bg} text-{$color}'>";
        $html .= "<{$balise}>{$text}</{$balise}>";
        $html .= "</div>";
        $html .= "</div>";
        $html .= "</div>";
        $html .= "</div>";
        $html .= "</div>";
        return $html;
    }

}

?>