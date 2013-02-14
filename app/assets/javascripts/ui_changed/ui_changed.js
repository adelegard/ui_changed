if (typeof(UiChanged) === 'undefined') {
  UiChanged = {
    _initialized: false,
    _clicked_urls_row: false,
    _crawlStatusIntervalId: null,

    /* selectors & classes used in the javascript below */

    _crawl_btn_selector:              '.crawl_btns .f_crawl_action',
    _crawl_btn_btn_selector:          '.crawl_btns button',
    _crawl_cancel_btn_selector:       '.crawl_btns .f_crawl_action.f_cancel',
    _crawling_urls_selector:          '.crawling .urls',
    _crawling_urls_li_selector:       '.crawling .urls li',
    _crawling_last_img_selector:      '.crawling a.last_img',
    _crawling_last_img_img_selector:  '.crawling a.last_img img',
    _crawling_no_diff_found_selector: '.crawling a.last_img .no_diff_found',
    _crawling_diff_found_selector:    '.crawling a.last_img .diff_found',
    _crawl_btn_running_class:         'running',

    _diff_or_no_diff_found_selector: '.diff_found, .no_diff_found',
    _crawling_urls_active_selector:  '.active',
    _crawling_urls_active_class:     'active',
    _no_diff_found_class:            'no_diff_found',
    _diff_found_class:               'diff_found',

    _checkbox_master_selector:         "#f_checkall",
    _checkbox_child_selector:          ".f_checkall_child",
    _checkbox_child_checked_selector:  ".f_checkall_child:checked",

    _element_db_id_selector:            '.f_id',
    _row_selector:                      '.screenshots tbody tr',
    _diffs_row_selector:                '.screenshots.diffs tbody tr',
    _row_checkbox_not_checked_selector: 'td:first input[type=checkbox]:not(:checked)',

    _action_btn_selector:                  ".f_actions button",
    _action_remove_selector:               ".f_actions .f_remove",
    _action_remove_test_and_diff_selector: ".f_actions .f_remove_test_and_diff",
    _action_ignore_selector:               ".f_actions .f_ignore",
    _action_set_test_as_control_selector:  ".f_actions .f_set_test_as_control",

    _action_remove_all_diffs_and_tests_selector: ".f_bulk_actions .f_remove_all_diffs_and_tests",
    _action_remove_all_selector:                 ".f_bulk_actions .f_remove_all",
    _action_ignore_all_selector:                 ".f_bulk_actions .f_ignore_all_urls",
    _action_set_all_tests_as_control_selector:   ".f_bulk_actions .f_set_all_tests_as_control",

    _on_homepage_selector: '.f_on_home_page',

    _sidenav_diffs_count_selector:    '.f_sidenav_diffs span:last',
    _sidenav_controls_count_selector: '.f_sidenav_controls span:last',
    _sidenav_tests_count_selector:    '.f_sidenav_tests span:last',
    _sidenav_compares_count_selector: '.f_sidenav_compares span:last',

    /* url selectors */
    _action_set_test_as_control_url_selector: '.f_set_test_as_control_url',
    _remove_url_selector:                     '.f_remove_url',
    _diffs_url_selector:                      '.f_diff_url',
    _crawl_status_url_selector:               '.f_crawl_status_url',
    _add_ignore_url_selector:                 '.f_ignore_url_add',

    _init: function() {
      if(this._initialized) return;

      $(this._crawl_btn_selector).not(this._crawl_cancel_btn_selector).click(this._crawl_btns_clicked);
      $(this._crawl_cancel_btn_selector).click(this._crawl_btn_cancel_clicked);
      $(this._crawling_urls_selector).on('click', 'li:not(' + this._crawling_urls_active_selector + ')', this._crawling_urls_clicked);

      $(this._checkbox_master_selector).change(this._checkall_master_change);
      $(this._checkbox_child_selector).change(this._checkall_child_change);
      $(this._diffs_row_selector).click(this._diffs_row_clicked);

      $(this._action_remove_selector).click(this._actions_remove);
      $(this._action_remove_test_and_diff_selector).click(this._actions_remove_test_and_diff);
      $(this._action_ignore_selector).click(this._actions_ignore);
      $(this._action_set_test_as_control_selector).click(this._actions_set_test_as_control);

      $(this._action_remove_all_diffs_and_tests_selector).click(this._bulk_actions_remove_all_diffs_and_tests);
      $(this._action_remove_all_selector).click(this._bulk_actions_remove_all);
      $(this._action_ignore_all_selector).click(this._bulk_actions_ignore_all_urls);
      $(this._action_set_all_tests_as_control_selector).click(this._bulk_actions_set_all_tests_as_control);

      if ($(this._crawl_cancel_btn_selector).is(':visible')) $(this._crawl_btn_btn_selector).not(this._crawl_cancel_btn_selector).attr("disabled", "disabled");

      if ($(this._on_homepage_selector).val() === "true") this._update_crawl_status();

      this._disable_action_buttons();
      this._initialized = true;
    },

    /* individual actions */
    _actions_remove: function() {
      UiChanged._ajax_with_type($(UiChanged._remove_url_selector).val() + UiChanged._get_checked_ids(), "DELETE");
    },
    _actions_remove_test_and_diff: function() {
      UiChanged._ajax_with_type($(this).attr("data-href") + "?id=" + UiChanged._get_checked_ids(), "DELETE");
    },
    _actions_ignore: function() {
      UiChanged._ajax_with_type($(UiChanged._add_ignore_url_selector).val() + UiChanged._get_checked_ids(), "POST");
    },
    _actions_set_test_as_control: function() {
      UiChanged._ajax_with_type($(UiChanged._action_set_test_as_control_url_selector).val() + '?id=' + UiChanged._get_checked_ids(), "POST");
    },

    /* bulk actions */
    _bulk_actions_remove_all_diffs_and_tests: function() {
      UiChanged._ajax_with_type($(this).attr("data-href"), "DELETE");
    },
    _bulk_actions_remove_all: function() {
      UiChanged._ajax_with_type($(this).attr("data-href"), "DELETE");
    },
    _bulk_actions_ignore_all_urls: function() {
      UiChanged._ajax_with_type($(this).attr("data-href"), "POST");
    },
    _bulk_actions_set_all_tests_as_control: function() {
      UiChanged._ajax_with_type($(this).attr("data-href"), "POST");
    },

    _crawl_btns_clicked: function() {
      $(UiChanged._crawl_btn_btn_selector).not(UiChanged._crawl_cancel_btn_selector).attr("disabled", "disabled");
      $(UiChanged._crawl_cancel_btn_selector).show();

      $.ajax({
        url: $(this).attr('data-action'),
        type: 'POST',
        success: function(data) {
          $(UiChanged._crawling_urls_li_selector).remove();
          UiChanged._update_crawl_status();
        }
      });
    },

    _crawl_btn_cancel_clicked: function() {
      $(this).attr("disabled", "disabled");
      $.ajax({
        url: $(this).attr('data-action'),
        type: 'POST'
      });
    },

    _crawling_urls_clicked: function() {
      var elem = $(this);
      if (elem.prev().length === 0) {
        // reset our boolean
        UiChanged._clicked_urls_row = false;
        $(UiChanged._crawling_urls_li_selector).removeClass(UiChanged._crawling_urls_active_class);
        elem.addClass(UiChanged._crawling_urls_active_class);
      } else {
        UiChanged._clicked_urls_row = true;
      }

      var anchor = elem.find('a');
      if (typeof anchor.attr('data-alt') === 'undefined') return;
      $(UiChanged._crawling_urls_li_selector).removeClass(UiChanged._crawling_urls_active_class);
      elem.addClass(UiChanged._crawling_urls_active_class);

      var is_compare = anchor.find(UiChanged._diff_or_no_diff_found_selector).length === 1;
      var diff_found = anchor.find(UiChanged._diff_found_class).length === 1;

      UiChanged._add_crawl_image_with_src({
        'file_name': anchor.attr('data-alt'),
        'src':anchor.attr('data-src'),
        'crawl_url': anchor.attr('href'),
        'is_compare': is_compare,
        'diff_found': diff_found});
    },

    _update_crawl_status: function() {
      $.ajax({
        dataType: "json",
        url: $(UiChanged._crawl_status_url_selector).val(),
        success: function(data) {
          var screenshots = data[0].screenshots;
          var running_status = data[0].worker.running_status;
          var first_status = data[0].worker.first_status;
          var running_type = data[0].worker.running_type;
          $(UiChanged._crawl_btn_selector).removeClass(UiChanged._crawl_btn_running_class);
          $(UiChanged._crawl_btn_with_type(running_type)).addClass(UiChanged._crawl_btn_running_class);
          $(UiChanged._crawling_last_img_img_selector).removeAttr("src");
          $(UiChanged._crawling_last_img_img_selector).removeAttr("alt");

          $(UiChanged._sidenav_diffs_count_selector).text(data[0].counts.diff);
          $(UiChanged._sidenav_controls_count_selector).text(data[0].counts.control);
          $(UiChanged._sidenav_tests_count_selector).text(data[0].counts.test);
          $(UiChanged._sidenav_compares_count_selector).text(data[0].counts.compare);

          for (var i=0; i < screenshots.length; i++) {
            UiChanged._add_crawl_url(screenshots[i]);
          }
          if (screenshots.length > 0 && !UiChanged._clicked_urls_row) {
            /* if the user isn't looking at other rows, then show the most recent image */
            UiChanged._show_top_most_image();
          }

//          $('.cmd_status_msg').text('running: ' + running_status + ' first: ' + first_status);
          clearInterval(UiChanged._crawlStatusIntervalId);
          if (running_status === "working" || (first_status === "working" || first_status === "queued")) {
            UiChanged._crawlStatusIntervalId = setInterval(UiChanged._update_crawl_status, 3000);
            return;
          }
          $(UiChanged._crawl_btn_btn_selector).removeAttr("disabled");
          $(UiChanged._crawl_cancel_btn_selector).hide();
        }
      });
    },

    _show_top_most_image: function() {
      $(UiChanged._crawling_urls_li_selector).each(function() {
        var elem = $(this);
        var anchor = elem.find('a');
        if (anchor.hasClass(UiChanged._crawling_urls_active_class)) return;
        var src = anchor.attr('data-src');
        if (typeof src !== 'undefined') {
          UiChanged._add_crawl_image_with_src({
            'file_name': anchor.attr('data-alt'),
            'src': src,
            'crawl_url': anchor.attr('data-href'),
            'is_compare': anchor.attr('data-type') === 'compare',
            'diff_found': anchor.find('i').hasClass(UiChanged._diff_found_class)});
          return false;
        }
      });
    },

    _add_crawl_url: function(screenshot) {
      if (screenshot.url === null) return;

      if ($(UiChanged._crawling_urls_li_selector).length > 100) {
        $(UiChanged._crawling_urls_selector).empty();
      }

      var type = "test";
      var diff_class = "";
      if (screenshot.is_control === true) {
        type = "control";
      } else if (screenshot.is_compare === true) {
        diff_class = screenshot.diff_found === true ? UiChanged._diff_found_class : UiChanged._no_diff_found_class;
        diff_class = " " + diff_class;
        type = "compare";
      }

      var file_name = screenshot.image_file_name;
      var src;
      var icon_class;
      if (file_name !== null) {
        src = screenshot.displayable_image_path_full;
        icon_class = 'icon-picture' + diff_class;
      } else {
        icon_class = 'icon-';
      }

      var existing_selector = UiChanged._crawling_url_with_href_and_type(screenshot.url, type);
      var existing = $(existing_selector);
      if (existing.length === 0) {
        $(UiChanged._crawling_urls_selector).prepend('<li><a data-type="' + type + '" data-href="' + screenshot.url + '"><i></i><span>' + type + ' : ' + screenshot.url + '</span></a></li>');
        existing = $(existing_selector);
      }
      if (typeof existing.attr('data-alt') === 'undefined' && src !== null) {
        existing.find('i').attr('class', icon_class);
        existing.attr('data-alt', file_name);
        existing.attr('data-src', src);
      }
    },

    _add_crawl_image_with_src: function(params) {
      // don't replace the image with itself
      var existing_img = $(UiChanged._crawling_last_img_img_selector + '[src="' + params.src + '"]').length;
      if (existing_img > 0) return;

      if (params.is_compare) {
        if (params.diff_found === null || params.diff_found === false) {
          $(UiChanged._crawling_no_diff_found_selector).show();
          $(UiChanged._crawling_diff_found_selector).hide();
          $(UiChanged._crawling_last_img_img_selector).hide();
        } else {
          $(UiChanged._crawling_no_diff_found_selector).hide();
          $(UiChanged._crawling_diff_found_selector).show();
          $(UiChanged._crawling_last_img_img_selector).show();
        }
      } else {
        $(UiChanged._crawling_no_diff_found_selector).hide();
        $(UiChanged._crawling_diff_found_selector).hide();
        $(UiChanged._crawling_last_img_img_selector).show();
      }
      $(UiChanged._crawling_last_img_selector).attr('href', params.src);
      $(UiChanged._crawling_last_img_img_selector).attr('alt', params.file_name);
      $(UiChanged._crawling_last_img_img_selector).attr('src', params.src);

      if (UiChanged._clicked_urls_row) return;
      $(UiChanged._crawling_urls_li_selector).removeClass(UiChanged._crawling_urls_active_class);
      $(UiChanged._crawling_url_with_href(params.crawl_url)).parent('li').addClass(UiChanged._crawling_urls_active_class);
    },

    _checkall_master_change: function() {
      $(UiChanged._checkbox_child_selector).prop("checked", this.checked);
      UiChanged._disable_action_buttons();
    },
    _checkall_child_change: function() {
      $(UiChanged._checkbox_master_selector).prop("checked", $(UiChanged._checkbox_child_checked_selector).length == $(UiChanged._checkbox_child_selector).length);
      UiChanged._disable_action_buttons();
    },
    _diffs_row_clicked: function(e) {
      if (e.target.type === 'checkbox') return;
      document.location = $(this).find(UiChanged._diffs_url_selector).val();
    },

    _disable_action_buttons: function() {
      $(UiChanged._action_btn_selector).attr("disabled", $(UiChanged._checkbox_child_checked_selector).length === 0);
    },
    _ajax_with_type: function(url, type) {
      $.ajax({
        url: url,
        type: type,
        success: function() {
          location.reload();
        }
      });
    },
    _get_checked_ids: function() {
      var ids_array = [];
      $(UiChanged._row_selector).each(function() {
        var row = $(this);
        if (!row.find(UiChanged._row_checkbox_not_checked_selector).length) {
          var diff_id = row.find(UiChanged._element_db_id_selector).first().val();
          ids_array.push(diff_id);
        }
      });
      return ids_array.join(",");
    },
    _crawl_btn_with_type: function(type) {
      return UiChanged._crawl_btn_selector + '[data-type="' + type + '"]';
    },
    _crawling_url_with_href: function(href) {
      return UiChanged._crawling_urls_li_selector + ' a[data-href="' + href +'"]';
    },
    _crawling_url_with_href_and_type: function(href, data_type) {
      return UiChanged._crawling_urls_li_selector + ' a[data-href="' + href + '"][data-type="' + data_type + '"]';
    }
  };
}

$(function() {
  UiChanged._init();
});
