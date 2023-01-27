"use strict";

var version = "1.1.0";
var namespace = "yearpicker";

if (!jQuery) {
  alert(namespace + " " + version + " requires jQuery");
}

var defaults = {
  // The Initial Date
  year: null,
  // Start Date
  startYear: null,
  // End Date
  endYear: null,
  // A element tag items
  itemTag: "li",
  //css class selected date item
  selectedClass: "selected",
  // css class disabled
  disabledClass: "disabled",
  hideClass: "hide",
  template: "<div class=\"yearpicker-container\">\n<div class=\"yearpicker-header\">\n<div class=\"yearpicker-prev\" data-view=\"yearpicker-prev\">&lsaquo;</div>\n<div class=\"yearpicker-current\" data-view=\"yearpicker-current\">SelectedYear</div>\n<div class=\"yearpicker-next\" data-view=\"yearpicker-next\">&rsaquo;</div>\n</div>\n<div class=\"yearpicker-body\">\n<ul class=\"yearpicker-year\" data-view=\"years\">\n</ul>\n</div>\n</div>\n",

  // Event shortcuts
  onShow: null,
  onHide: null,
  onChange: null
};

var event_click = "click.";
var event_focus = "focus.";
var event_keyup = "keyup.";
var event_selected = "selected.";
var event_show = "show.";
var event_hide = "hide.";

var methods = {
  // Show datepicker
  showView: function showView() {
    var $this = this;

    if (!$this.build) {
      $this.init();
    }

    if ($this.show) {
      return;
    }

    $this.show = true;
    var $template = $this.$template,
        options = $this.options;

    $template.removeClass(options.hideClass).on(event_click, $.proxy($this.click, $this));
    $(document).on(event_click, this.onGlobalClick = $.proxy($this.globalClick, $this));

    if (options.onShow && $.isFunction(options.onShow)) {
      options.onShow($this.year);
    }
  },

  // Hide the datepicker
  hideView: function hideView() {
    var $this = this;

    if (!$this.show) {
      return;
    }

    // if ($this.trigger(event_hide).isDefaultPrevented()) {
    //   return;
    // }

    var $template = $this.$template,
        options = $this.options;

    $template.addClass(options.hideClass).off(event_click, $this.click);
    $(document).off(event_click, $this.onGlobalClick);
    $this.show = false;

    if (options.onHide && $.isFunction(options.onHide)) {
      options.onHide($this.year);
    }
  },
  // toggle show and hide
  toggle: function toggle() {
    if (this.show) {
      this.hideView();
    } else {
      this.show();
    }
  }
};

var handlers = {
  click: function click(e) {
    var $target = $(e.target),
        viewYear = this.viewYear;

    if ($target.hasClass("disabled")) {
      return;
    }

    var view = $target.data("view");
    switch (view) {
      case "yearpicker-prev":
        var year = viewYear - 12;
        this.viewYear = year;
        this.renderYear();
        break;
      case "yearpicker-next":
        var year = viewYear + 12;
        this.viewYear = year;
        this.renderYear();
        break;
      case "yearpicker-items":
        this.year = parseInt($target.html());
        this.renderYear();
        this.hideView();
        break;
      default:
        break;
    }
  },
  globalClick: function globalClick(_ref) {
    var target = _ref.target;
    var element = this.element;
    var hidden = true;

    if (target !== document) {
      while (target === element || $(target).closest(".yearpicker-header").length === 1) {
        hidden = false;
        break;
      }

      target = target.parentNode;
    }

    if (hidden) {
      this.hideView();
    }
  }
};

var render = {
  renderYear: function renderYear() {
    var $this = this,
        options = this.options,
        startYear = options.startYear,
        endYear = options.endYear;

    var disabledClass = options.disabledClass,
        viewYear = $this.viewYear,
        selectedYear = ($this.year == null) ? '선택' : $this.year,
        now = new Date(),
        thisYear = now.getFullYear(),
        start = -5,
        end = 6,
        items = [];

    var prevDisabled = false;
    var nextDisabled = false;
    var i = void 0;

    for (i = start; i <= end; i++) {
      var year = viewYear + i;
      var disabled = false;

      if (startYear) {
        disabled = year < startYear;
        if (i === start) {
          prevDisabled = disabled;
        }
      }

      if (!disabled && endYear) {
        disabled = year > endYear;
        if (i === end) {
          nextDisabled = disabled;
        }
      }

      // check for this is a selected year
      var isSelectedYear = year === selectedYear;
      var view = isSelectedYear ? "yearpicker-items" : "yearpicker-items";
      items.push($this.createItem({
        selected: isSelectedYear,
        disabled: disabled,
        text: viewYear + i,
        //view: disabled ? "yearpicker disabled" : view,
        view: disabled ? "yearpicker-items disabled" : view,
        highlighted: year === thisYear
      }));
    }

    $this.yearsPrev.toggleClass(disabledClass, prevDisabled);
    $this.yearsNext.toggleClass(disabledClass, nextDisabled);
    $this.yearsCurrent.html(selectedYear);
    $this.yearsBody.html(items.join(" "));
    $this.setValue();
  }
};

var Yearpicker = function () {
  function YearPicker(element, options) {
    var $this = this;

    $this.options = $.extend({}, defaults, options);
    $this.$element = $(element);
    $this.element = element;
    $this.build = false;
    $this.show = false;
    $this.startYear = null;
    $this.endYear = null;
    $this.$template = $($this.options.template);

    $this.init();
  }

  YearPicker.prototype = {
    /**
     * constructor
     * configure the yearpicker before initialize
     * @returns {null}
     */
    init: function init() {
      var $this = this,
          $element = this.$element,
          options = this.options;

      if (this.build) {
        return;
      }
      $this.build = true;

      var startYear = options.startYear,
          endYear = options.endYear,
          defaultYear = $this.getValue(),
          $template = $this.$template;

      var year = options.year;

      $this.isInput = $element.is("input") || $element.is("textarea");
      $this.initialValue = defaultYear;
      $this.oldValue = defaultYear;

      var currentYear = new Date().getFullYear();
      // set the defaultyear
      year = year || defaultYear || null;

      // set the startyear
      if (startYear) {
        if (year && year < startYear) {
          year = startYear;
        }
        $this.startYear = startYear;
      }

      // set the endyear
      if (endYear) {
        if (year && year > endYear) {
          year = endYear;
        }
        $this.endYear = endYear;
      }

      $this.year = year;
      $this.viewYear = year || currentYear;
      $this.initialYear = year || currentYear;

      $this.bind();

      $this.yearsPrev = $template.find(".yearpicker-prev");
      $this.yearsCurrent = $template.find(".yearpicker-current");
      $this.yearsNext = $template.find(".yearpicker-next");
      $this.yearsBody = $template.find(".yearpicker-year");

      $template.addClass(options.hideClass);
      $element.after($template.addClass(namespace + "-dropdown"));
      $this.renderYear();
    },
    // assign a events
    bind: function bind() {
      var $this = this,
          $element = this.$element,
          options = this.options;

      if ($.isFunction(options.show)) {
        $element.on(event_show, options.show);
      }
      if ($.isFunction(options.hide)) {
        $element.on(event_hide, options.hide);
      }
      if ($.isFunction(options.click)) {
        $element.on(event_click, options.click);
      }
      if ($this.isInput) {
        $element.on(event_focus, $.proxy($this.showView, $this));
      } else {
        $element.on(event_click, $.proxy($this.showView, $this));
      }
    },
    getValue: function getValue() {
      var $this = this,
          $element = this.$element;

      var value = $this.isInput ? $element.val() : $element.text();
      return parseInt(value);
    },
    setValue: function setValue() {
      var $this = this,
          $element = this.$element,
          options = this.options,
          value = this.year;
      var previousValue = $this.isInput ? $element.val() : $element.text();

      if ($this.isInput) {
        $element.val(value);
      } else {
        $element.html(value);
      }

      if (previousValue != value) {
        if (options.onChange && $.isFunction(options.onChange)) {
          options.onChange($this.year);
        }
      }

      $element.trigger("change");
    },
    trigger: function trigger(type, data) {
      data = data || this.year;
      var e = $.Event(type, data);
      this.$element.trigger(e);
      return e;
    },
    createItem: function createItem(data) {
      var options = this.options,
          itemTag = options.itemTag,
          classes = [];

      var items = {
        text: "",
        view: "",
        selected: false,
        disabled: false,
        highlighted: false
      };

      $.extend(items, data);
      if (items.selected) {
        classes.push(options.selectedClass);
      }

      if (items.disabled) {
        classes.push(options.disabledClass);
      }

      return "<" + itemTag + " class=\"" + items.view + " " + classes.join(" ") + "\" data-view=\"" + items.view + "\">" + items.text + "</" + itemTag + ">";
    }
  };

  return YearPicker;
}();

if ($.extend) {
  $.extend(Yearpicker.prototype, methods, render, handlers);
}

if ($.fn) {
  $.fn.yearpicker = function jQueryYearpicker(options) {
    var result = void 0;

    this.each(function (index, element) {
      var $element = $(element);
      var isDestory = options === "destroy";
      var yearpicker = $element.data(namespace);

      if (!yearpicker) {
        if (isDestory) {
          return;
        }
        yearpicker = new Yearpicker(element, options);
        $element.data(namespace, yearpicker);
      }
      if (typeof options === "string") {
        var fn = yearpicker[options];

        if ($.isFunction(fn)) {
          result = fn.apply(yearpicker, args);

          if (isDestory) {
            $element.removeData(namespace);
          }
        }
      }
    });

    return !result ? result : this;
  };
  $.fn.yearpicker.constractor = Yearpicker;
}