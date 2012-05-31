function appendOne(to,from) {   //TODO test
    box1=document.getElementById(to);
    box2=document.getElementById(from);
    if(box1.options.selectedIndex < 0)
        return false;
    var val_box1 =  box1.options[box1.selectedIndex].value;
    var text_box1 = box1.options[box1.selectedIndex].text;
    box2.options[box2.options.length] = new Option(text_box1, val_box1, false, false);
    box1.options[box1.selectedIndex] = null;
}