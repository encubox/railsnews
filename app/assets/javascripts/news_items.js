$(function() {
   // jRating is not a good plugin, but it works in this simple case.
   
   $("#stars").jRating({
      step: true,
      canRateAgain: false,      
      phpPath: '/news_items/rate',      
      onError: function() {
      	alert('Error: Rating was not sent!');
      }
    });
});