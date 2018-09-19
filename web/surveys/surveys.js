
/*
*
*
* let's see what gives
*
*/

function proceed(){
   document.qform.NEXTGROUP.value=parseInt(document.qform.CURRENTGROUP.value)+1
}

function skipto(where){
        document.qform.NEXTGROUP.value=where
}


function complain(){
   if (document.qform.NEXTGROUP.value==document.qform.CURRENTGROUP.value) {
    alert(
        "\n\n"+
        "__________________________________________________"+
        "\n\n"+
        "Πρέπει να απαντήσετε την ερώτηση για να προχωρήσετε!"+
        "\n\n"+
        "You have to answer this question to proceed"+
        "\n\n\n"
        )
    return false
   }
   else { 
        document.qform.submit()
        return true
   }

}

function validate_number(name){
   for ( var i=0; i< document.qform.elements.length; i++) {
        var temp=document.qform.elements[i].name
        if ( temp==name) {
                var mynumber1=parseInt(document.qform.elements[i].value)
                var mynumber2=parseFloat(document.qform.elements[i].value)
                if  ( isNaN(mynumber1) || isNaN(mynumber2) ) {
                   alert(
                        "\n\n\n"+
                        "____________________________________________________"+
                        "\n\n"+
                        "Αυτός δεν είναι αριθμός. Σας παρακαλώ ξαναγράψτε τον"+
                        "\n\n"+
                        "This is not a number.please type a number"+
                        "\n\n"
                   );
                        document.qform.elements[i].value='';
                        document.qform.elements[i].focus();
                } 
                else 
                {
                        proceed();
                }
        }
   }
}


function number_range_check(name,start,end){
var myvalue=0;
var myintvalue=0;
var myfloatvalue=0;
   for ( var i=0; i< document.qform.elements.length; i++) {
        var temp=document.qform.elements[i].name;
        if ( temp==name) {
                myvalue=parseInt(document.qform.elements[i].value) - 0;
                myintvalue=parseInt(document.qform.elements[i].value)
                myfloatvalue=parseFloat(document.qform.elements[i].value)
                if (  isNaN(myintvalue) || isNaN(myfloatvalue) ||
                         ( myvalue<start )  || ( myvalue>end)  ) {
                        alert (
                                " Σας παρακαλώ δωστε μια τιμη μεταξύ "+
                                start+
                                " και "+
                                end+
                                "\n\n"+
                                "Please enter a value between "+
                                start+
                                " and "+
                                end
                        );
                } else{ 
                        proceed(); 
                }
        }
   }
}


function setvar(name,val){
var j=0;
        for ( var i=0; i< document.qform.elements.length; i++) {
                var temp=document.qform.elements[i].name;
                if ( temp==name) {
			j=i;
		}
	}
       document.qform.elements[j].value=val;
       document.qform.elements[j].checked=1;
       document.qform.elements[j].focus();
                
 proceed();
}



