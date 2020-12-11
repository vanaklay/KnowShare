function inTableSearch() {
  $(document).ready(function(){
    $("#myInput").on("keyup", function() {
      var value = $(this).val().toLowerCase();
      $("#myTable tr").filter(function() {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
      });
      $("#myTable2 tr").filter(function() {
        $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
      });
    });
  });
};

inTableSearch();

function lessonSearch() {
  $(document).ready(function(){
    $("#myLessonInput").on("keyup", function() {
      var lessonValue = $(this).val().toLowerCase();
      $("#myLessonSearch *").filter(function() {
        $(this).toggle($(this).text().toLowerCase().indexOf(lessonValue) > -1)
      });
    });
  });
};

lessonSearch();
