function unlockForm(){
    var form = document.getElementById("myform");
    form.style.display = 'block';
    form.removeAttribute("disabled");
}

function trim(s) {
    if (s == null) {
        return '';
    }
    while (s.substring(0, 1) == ' ') {
        s = s.substring(1, s.length);
    }
    while (s.substring(s.length - 1, s.length) == ' ') {
        s = s.substring(0, s.length - 1);
    }
    return s;
}

function validateName(){
    var regex = /^[A-Z][a-z]+/;
    var nonempty = /.+/;
    var name = document.getElementById("name");
    if(!nonempty.test(trim(name.value))){
        alert('Invalid data - name field cannot be empty!');
        name.style.backgroundColor = 'red';
        return false;
    }else if(!regex.test(trim(name.value))){
        alert('Invalid data - name field should be filled as follows: /^[A-Z][a-z]+/');
        name.style.backgroundColor = 'red';
        return false;
    }
    name.style.backgroundColor = 'green';
    return true;
}

function fillLogin(){
    var name = document.getElementById("name");

    var login = document.getElementById("login");
    var newValue = name.value.toUpperCase();
    login.value = newValue + "@MINI.PW";
    return true;

}

function validatePassword(){
    var name = document.getElementById("name");
    var password = document.getElementById("password");
    var passRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}/;
    var myForm = document.getElementById("myform");

    // Tu powinno byc usuwanie starych labeli, ale za pozno o tym pomyslalam

    nameStr = name.value;
    var passwordValue = trim(password.value);

    for(i=0; i<nameStr.length; i++){
        var nameSubstr = nameStr.substring(i, i+1);
        if(passwordValue.includes(nameSubstr)){
            password.style.backgroundColor = 'red';
            var errTxt = document.createTextNode("Password contains name substring ");
            var newLabel = document.createElement('label');
            newLabel.style.backgroundColor = "pink";
            newLabel.appendChild(errTxt);
            myForm.appendChild(newLabel);
            return false;
        }else if(!passRegex.test(passwordValue)){
            var errTxt = document.createTextNode('Password should contain capital letter, small letter and digit and have at least 8 characters. ');
            var newLabel = document.createElement('label');
            newLabel.appendChild(errTxt);
            newLabel.style.backgroundColor = "pink";
            newLabel.className = 'errorLabel';
            myForm.appendChild(newLabel);
            password.style.backgroundColor = 'red';
            return false;
        }
    }
    password.style.backgroundColor = 'green';
    return true;
}

function timeMeasure(){
    var startTime = new Date();
    var endTime, timeDiff, time;

    if(validateName() == true && validatePassword() == true){
        endTime = new Date();
        timeDiff = endTime - startTime;
        time = timeDiff.toString();

        var txt = document.createTextNode(time);
        var label = document.createElement('label');
        label.appendChild(txt);
        document.body.appendChild(label);
    }    
    // setTimeout(timeMeasure(), 3000);
    // Ta funkcja powinna byc dopisana przy onclick Start, ale z powodu nieusuniecia 
    // starych labeli w funkcji validujacej haslo zasmieciloby to plik

}





