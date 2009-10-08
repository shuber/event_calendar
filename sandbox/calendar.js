var Calendar = Class.create({
  
  initialize: function(element) {
    this.element = element;
    this.events = $$('#' + this.element.id + ' ' + Calendar.events_css_path);
    
    this.events.each(function(event) {
      var related_events = this.related_events_for(event);
      
      event.observe('mouseover', function() {
        related_events.each(function(related_event) {
          related_event.addClassName('hover');
        }); 
      });
      
      event.observe('mouseout', function() {
        related_events.each(function(related_event) {
          related_event.removeClassName('hover');
        });
      });
    }.bind(this));
  },
  
  related_events_for: function(event) {
    var regex = new RegExp('^' + event.id.replace(/(\d+)_(\d+)/, '$1'));
    return this.events.select(function(related_event) {
      return event != related_event && regex.test(related_event.id);
    });
  }
  
});

Calendar.events_css_path = '.event a';
Calendar.instances = [];

document.observe('dom:loaded', function() {
  $$('.calendar').each(function(element) {
    Calendar.instances.push(new Calendar(element));
  });
});