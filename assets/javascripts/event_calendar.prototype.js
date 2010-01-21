var EventCalendar = Class.create({

  options: $H({ 
    events_css_path: '.event', 
    event_fields_css_path: '.fields span',
    event_hover_class: 'hover'
  }),
  
  initialize: function(element, options) {
    this.element = element;
    this.options = this.options.merge(options || {});
    this.events = $$('#' + this.element.id + ' ' + this.options.get('events_css_path'));
    
    this.events.each(function(event) {
      this.add_fields_to_event(event);
      this.add_hover_behavior_to_event(event);
    }.bind(this));
    
    EventCalendar.instances.push(this);
  },
  
  add_fields_to_event: function(event) {
    event.fields = $$('#' + event.id + ' ' + this.options.get('event_fields_css_path')).inject({}, function(fields, element) {
      fields[element.title] = element.innerHTML;
      return fields;
    });
  },
  
  add_hover_behavior_to_event: function(event) {
    var hover_class_name = this.options.get('event_hover_class');    
    var related_events = this.related_events_for(event);
    
    event.observe('mouseover', function() {
      related_events.each(function(related_event) {
        related_event.addClassName(hover_class_name);
      });
    });
    
    event.observe('mouseout', function() {
      related_events.each(function(related_event) {
        related_event.removeClassName(hover_class_name);
      });
    });
  },
  
  related_events_for: function(event) {
    var regex = new RegExp('^' + event.id.replace(/(\d+)_(\d+)/, '$1'));
    return this.events.select(function(related_event) {
      return event != related_event && regex.test(related_event.id);
    });
  }
  
});

EventCalendar.instances = [];