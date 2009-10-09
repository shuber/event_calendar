var Calendar = Class.create({

  options: $H({ 
    events_css_path: '.event', 
    event_fields_css_path: '.fields span',
    event_hover_class: 'hover'
  }),
  
  initialize: function(element, options) {
    this.element = element;
    this.options = this.options.merge(options || {});
    this.events = $$('#' + this.element.id + ' ' + this.options.get('events_css_path'));
    
    this.add_fields_to_events();
    this.add_hover_behavior_to_events();
    
    Calendar.instances.push(this);
  },
  
  add_fields_to_events: function() {
    this.events.each(function(event) {
      event.fields = $$('#' + event.id + ' ' + this.options.get('event_fields_css_path')).inject({}, function(fields, element) {
        fields[element.title] = element.innerHTML;
        return fields;
      });
    }.bind(this));
  },
  
  add_hover_behavior_to_events: function() {
    var hover_class_name = this.options.get('event_hover_class');
    
    this.events.each(function(event) {
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
    }.bind(this));
  },
  
  related_events_for: function(event) {
    var regex = new RegExp('^' + event.id.replace(/(\d+)_(\d+)/, '$1'));
    return this.events.select(function(related_event) {
      return event != related_event && regex.test(related_event.id);
    });
  }
  
});

Calendar.instances = [];