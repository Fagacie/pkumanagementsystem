/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener('DOMContentLoaded', function() {
    // Get modal elements
    const modal = document.getElementById('deleteConfirmationModal');
    const closeButton = document.querySelector('.modal .close-button');
    const cancelDeleteButton = document.getElementById('cancelDeleteButton');
    const confirmDeleteButton = document.getElementById('confirmDeleteButton');
    const modalPaymentID = document.getElementById('modalPaymentID');

    let paymentIDToDelete = null; // Variable to store the ID of the payment to be deleted

    // Add event listeners to all delete buttons in the table
    document.querySelectorAll('.delete-button').forEach(button => {
        button.addEventListener('click', function() {
            paymentIDToDelete = this.dataset.paymentId; // Get payment ID from data-payment-id attribute
            modalPaymentID.textContent = paymentIDToDelete; // Display ID in modal
            modal.style.display = 'flex'; // Show the modal (using flex for centering)
        });
    });

    // Event listener for closing the modal using the 'x' button
    if (closeButton) {
        closeButton.addEventListener('click', function() {
            modal.style.display = 'none';
            paymentIDToDelete = null; // Clear the stored ID
        });
    }

    // Event listener for the 'Cancel' button in the modal
    if (cancelDeleteButton) {
        cancelDeleteButton.addEventListener('click', function() {
            modal.style.display = 'none';
            paymentIDToDelete = null; // Clear the stored ID
        });
    }

    // Event listener for the 'Delete' confirmation button in the modal
    if (confirmDeleteButton) {
        confirmDeleteButton.addEventListener('click', function() {
            if (paymentIDToDelete) {
                // Redirect to the PaymentServlet with delete action and the payment ID
                window.location.href = 'payment?action=delete&paymentID=' + paymentIDToDelete;
            }
            modal.style.display = 'none'; // Hide the modal after action
        });
    }


    window.addEventListener('click', function(event) {
        if (event.target == modal) {
            modal.style.display = 'none';
            paymentIDToDelete = null; 
        }
    });
});