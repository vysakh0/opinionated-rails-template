App.User = DS.Model.extend({
  email: DS.attr('string'),
  name: DS.attr('string'),
  password: DS.attr('string'),
  password_confirmation: DS.attr('string'),
  role: DS.attr(),
  location: DS.attr('string'),
  phone_number: DS.attr('string'),
  info_added: DS.attr('boolean'),

  student: function () {
    return this.get('role') === 'admin' ;
  }.property('role'),
  normal: function () {
    return this.get('role') === 'normal' ;
  }.property('role'),

  alumni: function () {
    return this.get('role') === 'staff' ;
  }.property('role')
});
