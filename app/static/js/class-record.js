$(document).ready(function() {
    $('.delete-student').click(function(event) {
        event.preventDefault();
        var studentID = $(this).data('studentid');
        var firstname = $(this).data('firstname');
        var lastname = $(this).data('lastname');
        var csrfToken = $('meta[name=csrf-token]').attr('content');

        console.log(studentID)
        console.log(firstname)
        console.log(lastname)
        console.log(csrfToken)

        $('#askDelete .delete-modal-body').html(
            `<p>Do you want to delete the following Student?</p><strong>Student ID:</strong> ${studentID}
            <br><strong>Full name:</strong> ${firstname} ${lastname}`);

        $('#askDelete').modal('show');

        $('#askDelete .delete-button').off('click').on('click', function () {
            $.ajax({
                type: 'POST',
                url: `/class_record/delete_student//${studentID}`,
                headers: {
                    'X-CSRFToken': csrfToken
                },
                success: function (response) {
                    if (response.success) {
                        $(event.target).closest('tr').remove();
                        console.log('Student deleted successfully:', response);
                        flashMessage(response.flash_message.type, response.flash_message.message);
                        location.reload();
                    } else {
                        console.error('Error deleting Student:', response.error || 'Unknown error');
                        flashMessage('danger', response.error || 'Failed to delete Student');
                    }
                },
                error: function (error) {
                    console.error('Error deleting Student ASD:', error);
                    flashMessage('danger', 'Failed to delete Student');
                }
            });
            $('#askDelete').modal('hide');
        });
    });

    function flashMessage(type, message) {
        var flashMessageHTML = `
            <div class="alert alert-${type} alert-dismissible fade show" role="alert">
                <div class="d-flex justify-content-between align-items-center">
                    <span>${message}</span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>
        `;
        $('#flash-messages-container').append(flashMessageHTML);
    }
});
