App.ApplicationRoute = Ember.Route.extend({
  model: function () {
    return this.store.find('user', 'current').then(function (res) {
      return res;
    }, function () {
      return null;
    });
  }
});
