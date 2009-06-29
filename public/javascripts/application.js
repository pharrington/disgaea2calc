// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Event.observe(window, 'load', function() {
  if ($('calc_progress')) {
    $$('label.inprogress').invoke('hide');
    Event.observe('calc_progress', 'click', function() {
      $$('label.inprogress').invoke('show');
    });
  }
  if ($('add_specialists')) {
    $$('label.inprogress').invoke('show');
    SpecialistWizard.create();
    $('add_specialists').observe('click', SpecialistWizard.display.bind(SpecialistWizard));
    [$('killnone'), $('killsingle'), $('killdouble'), $('killcustom')].invoke('observe', 'click', setKills);
    $('killnone').click();
    maskRarity();
    $('rarity').observe('change', maskRarity);
  }
});

var Rarities = {
  1: "normal",
  1.25: "rare",
  1.5: "legendary",
  slots: {1: 4, 1.25: 5, 1.5: 6}
};

var Specialists = {
  '': 'None',
  'hp': 'Dietician',
  'sp': 'Master',
  'atk': 'Gladiator',
  'def': 'Sentry',
  'int': 'Tutor',
  'res': 'Physician',
  'hit': 'Marksman',
  'spd': 'Coach'
};

function maskRarity()
{
  var rarity = Rarities[$F('rarity')];
  //first hide everything above normal rarity
  $R(4, 10).collect(function(boss) {
    $('boss_label' + boss).hide();
  });
  $R(2, 3).collect(function(bill) {
    $('bill' + bill).hide();
  });

  //now show options for rare or legendary items
  if ($w('rare legendary').include(rarity)) {
    $R(4, 6).collect(function(boss) {
      $('boss_label' + boss).show();
    });
    $('bill2').show();
  }
  if (rarity == 'legendary') {
    $R(7, 10).collect(function(boss) {
      $('boss_label' + boss).show();
    });
    $('bill3').show();
  }
}

function setKills()
{
  var kills = 0;
  switch (this) {
    case $('killnone'): kills = 0; break;
    case $('killsingle'): kills = 1; break;
    case $('killdouble'): kills = 2; break;
    case $('killcustom'): $('bosses').show(); return;
  }
  $('bosses').hide();
  $('bosses').select('select').each(function(field) {
    field.selectedIndex = kills;
  });
}

var Floor = Class.create({
  initialize: function(floor, dk) {
    this.floor = floor;
    this.dk = dk;
  },
  header: function() {
    var header = 'Floor ' + this.floor + ' Specialists';
    if (this.dk) header += ' (post boss kill)';
    return header;
  },
  slots: function() {
    var slots = Rarities.slots[$F('rarity')];
    for (var i = 30; i < this.floor; i+= 30) {
      slots += parseInt($F('boss' + i));
    }
    if (this.dk) ++slots;
    return Math.min(8, slots);
  },
  prev: function() {
    var floor = this.floor;
    var kills;
    if (!this.dk && $w('40 70 100').include(floor)) {
      kills = $F('boss' + floor - 10);
      return kills == 2 ? new Floor(floor - 10, 1) : new Floor(floor - 10);
    }
    else if (this.dk) {
      return new Floor(floor);
    }
    else {
      return new Floor(Math.max(10, floor - 10));
    }
  },
  next: function() {
    var floor = this.floor;
    var kills;
    var rarityFloors = {30: 'normal', 60: 'rare', 100: 'legendary'};
    var rarity = Rarities[$F('rarity')];
    if ($A([30, 60, 90, 100]).include(floor)) {
      if (!this.dk) {
        kills = $F('boss' + floor);
        if (kills == 2) return new Floor(floor, 1);
      }
      return rarity == rarityFloors[floor] ? new Floor(floor, this.dk) : new Floor(Math.min(100, floor + 10));
    }
    else {
      return new Floor(Math.min(100, floor + 10), this.dk);
    }
  }
});

var SpecialistWizard = {
  currentFloor: new Floor(10),
  state: function() {
    return this.currentFloor;
  },
  next: function() {
    this.currentFloor = this.currentFloor.next();
  },
  prev: function() {
    this.currentFloor = this.currentFloor.prev();
  },
  finish: function() {
    $('specialist_wizard').hide();
  },
  setFields: function() {
    $w('hp sp atk def int res spd hit').each(function (stat) {
      var count = $('specialist_wizard').select('select').findAll(function(field) {
        return $F(field) == Specialists[stat];
      }).size();
      for (var floor = this.state().floor; floor <= 100; floor += 10) {
        if (!this.state().dk) {
          $('floor' + floor + stat).value = count;
        } else {
          $('floor' + Math.min(100, floor + 10) + stat).value = count;
        }
        $('floor' + floor + stat + '_second').value = count;
      }
    }, this);
  },
  readFields: function() {
    var specialists = $A();
    var floor = this.state().floor;
    $w('hp sp atk def int res spd hit').each(function(stat) {
      parseInt($F('floor' + floor + stat)).times(function() {
        specialists.push(stat);
      });
    });
    $('specialist_wizard').select('select').each(function(field) {
      var stat = specialists.pop();
      var options = $A(field.options);
      if (stat) {
        field.selectedIndex = options.indexOf(options.find(function(option) {
          return option.text == Specialists[stat];
        }));
      }
    });
  },

  create: function() {
    var container = new Element('div', {'id': 'specialist_wizard'});
    var anchor = new Element('a', {'name': 'specialist_wizard'});
    var header = new Element('h1').update(this.state().header());
    var form = new Element('form');
    var fieldset = new Element('fieldset');
    var controls = new Element('div');
    var nextControl = new Element('a', {'class': 'wizard_next'}).update('Next Floor');
    var finishControl = new Element('a', {'class': 'wizard_finish'}).update('Finish');
    finishControl.observe('click', (function() {
      this.setFields();
      this.finish();
    }).bind(this));
    nextControl.observe('click', (function() {
      this.setFields();
      this.next();
      this.display();
    }).bind(this));
    controls.insert(finishControl);
    controls.insert(nextControl);
    form.insert(fieldset);
    form.insert(controls);
    container.insert(anchor);
    container.insert(header); 
    container.insert(form);
    container.hide();
    $(document.body).insert(container);
  },
  display: function() {
    var select;
    var label;
    var wizardFields= $('specialist_wizard').select('fieldset').first();
    wizardFields.select('label').invoke('remove');
    this.state().slots().times(function() {
      label = new Element('label').update('Specialist type:');
      select = new Element('select');
      $H(Specialists).each(function(pair) {
        select.insert(new Element('option', {'name': pair.key.toLowerCase()}).update(pair.value));
      });
      label.insert(select);
      wizardFields.insert({'top': label});
    });
    this.readFields();
    $('specialist_wizard').select('h1').first().update(this.state().header());
    $('specialist_wizard').show();
  }    
};
