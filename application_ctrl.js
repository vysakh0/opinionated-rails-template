App.ApplicationController = Ember.ObjectController.extend({
  openLoginPopup: false,
  isOverlay: false,
  loading: false,
  isPanel: '',
  notification: '',
  isSignedIn: function() {
    return this.get('content') != null ;
  }.property('content'),

  notify: function(msg, type) {
    var notification = Em.Object.create({
      message: msg,
      type: type,
      persists: true
    });
    this.set('notification', notification);
  },

  removeNotification: function () {
    var notify = this.get('notification');
    this.set('isPanel', false);

    if (notify) {
      if (notify.persists) {
        notify.set('persists', null);
      } else {
        this.set('notification', null);
      }
    }
  },
  actions: {
    closeNotification: function() {
      this.set('notification', null);
    },
    toggleLoginPopup: function(){
      this.toggleProperty('openLoginPopup');
      this.toggleProperty('isOverlay');
      console.log(this.get('isOverlay'));
    },
    togglePanel: function(){
      this.toggleProperty('isPanel');
    }
  }
})

