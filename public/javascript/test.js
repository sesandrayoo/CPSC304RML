$(function ready() {

    //client side on submit
    $("#submitForm").submit(function (e) {
        console.log('submitted');
        e.preventDefault();

        var personInfo = {
            firstName: $('#fname').val(),
            lastName: $('#lname').val()
        }
           
        
        console.log(personInfo.firstName);


    $.ajax({
        url: '/landlordProfile',
        type: 'POST',
        contentType: 'application/json',
        dataType: 'json',
        data: personInfo,
        success: function (json, status, request) {
            // $('#order-request-status').removeClass();
            // $('#order-request-status').addClass('alert alert-success');
            // $('#order-request-status').html('Placed an order successfully!');
        },//end of success

    })
    })

})




//         $.ajax({
//             url: '/api/ordersList',
//             type: 'POST',
//             contentType: 'application/json',
//             dataType: 'json',
//             data: customerInfo,
//             success: function (json, status, request) {
//                 $('#order-request-status').removeClass();
//                 $('#order-request-status').addClass('alert alert-success');
//                 $('#order-request-status').html('Placed an order successfully!');
//             },//end of success
//             error: function (data, request, status, error) {
//                 var possibleErrors = data.responseJSON;
//                 console.log(possibleErrors);
//                 $('#order-request-status').empty();
//                 $('#order-request-status').removeClass();
//                 $('#order-request-status').addClass('alert alert-danger');
                
//                 //show the custom errors if error on specific input
//                 for(let error in possibleErrors){
//                     if(possibleErrors[error] != null) {
//                         $('#order-request-status').append("<p>",possibleErrors[error],"</p>");
//                     }
//                 }
//                 console.log('Request failed : ', status);
//             }//end of error
//         });
//     });
// });