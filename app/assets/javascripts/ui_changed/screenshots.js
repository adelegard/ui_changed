if (typeof(Screenshots) === 'undefined') {
  Screenshots = {
    _initialized: false,
    _clicked_urls_row: false,
    _crawlStatusIntervalId: null,

    _init: function() {
      if(this._initialized) return;

      $('.crawl_btns .f_crawl_action').not('.f_cancel').click(this._crawl_btns_clicked);
      $('.crawl_btns .f_crawl_action.f_cancel').click(this._crawl_btn_cancel_clicked);
      $('.crawling .urls').on('click', 'li:not(.active)', this._crawling_urls_clicked);

      $("#f_checkall").change(this._checkall_master_change);
      $(".f_checkall_child").change(this._checkall_child_change);
      $('table.screenshots.diffs tbody tr').click(this._diffs_row_clicked);

      $(".f_actions .f_remove").click(this._actions_remove);
      $(".f_actions .f_remove_test_and_diff").click(this._actions_remove_test_and_diff);
      $(".f_actions .f_ignore").click(this._actions_ignore);
      $(".f_actions .f_set_test_as_control").click(this._actions_set_test_as_control);

      $(".f_bulk_actions .f_remove_all_diffs_and_tests").click(this._bulk_actions_remove_all_diffs_and_tests);
      $(".f_bulk_actions .f_remove_all").click(this._bulk_actions_remove_all);
      $(".f_bulk_actions .f_ignore_all_urls").click(this._bulk_actions_ignore_all_urls);
      $(".f_bulk_actions .f_set_all_tests_as_control").click(this._bulk_actions_set_all_tests_as_control);

      if ($('.f_cancel').is(':visible')) $('.crawl_btns button').not('.f_cancel').attr("disabled", "disabled");

      if ($('.f_on_home_page').val() === "true") this._update_crawl_status();

      this._disable_action_buttons();
      this._initialized = true;
    },

    /* individual actions */
    _actions_remove: function() {
      Screenshots._ajax_with_type($('.f_remove_url').val() + Screenshots._get_checked_ids(), "DELETE");
    },
    _actions_remove_test_and_diff: function() {
      Screenshots._ajax_with_type($(this).attr("data-href") + "?id=" + Screenshots._get_checked_ids(), "DELETE");
    },
    _actions_ignore: function() {
      Screenshots._ajax_with_type("/screenshot_ignore_url/add?id=" + Screenshots._get_checked_ids(), "POST");
    },
    _actions_set_test_as_control: function() {
      Screenshots._ajax_with_type($('.f_set_test_as_control_url').val() + '?id=' + Screenshots._get_checked_ids(), "POST");
    },

    /* bulk actions */
    _bulk_actions_remove_all_diffs_and_tests: function() {
      Screenshots._ajax_with_type($(this).attr("data-href"), "DELETE");
    },
    _bulk_actions_remove_all: function() {
      Screenshots._ajax_with_type($(this).attr("data-href"), "DELETE");
    },
    _bulk_actions_ignore_all_urls: function() {
      Screenshots._ajax_with_type($(this).attr("data-href"), "POST");
    },
    _bulk_actions_set_all_tests_as_control: function() {
      Screenshots._ajax_with_type($(this).attr("data-href"), "POST");
    },

    _crawl_btns_clicked: function() {
      $('.crawl_btns button').not('.f_cancel').attr("disabled", "disabled");
      $('.crawl_btns .f_cancel').show();

      $.ajax({
        url: $(this).attr('data-action'),
        type: 'POST',
        success: function(data) {
          $('.crawling .urls li').remove();
          Screenshots._update_crawl_status();
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
        Screenshots._clicked_urls_row = false;
        $('.crawling .urls li').removeClass('active');
        elem.addClass('active');
      } else {
        Screenshots._clicked_urls_row = true;
      }

      var anchor = elem.find('a');
      if (typeof anchor.attr('data-alt') === 'undefined') return;
      $('.crawling .urls li').removeClass('active');
      elem.addClass('active');

      var is_compare = anchor.find('i.diff_found, i.no_diff_found').length === 1;
      var diff_found = anchor.find('i.diff_found').length === 1;

      Screenshots._add_crawl_image_with_src({
        'file_name': anchor.attr('data-alt'),
        'src':anchor.attr('data-src'),
        'crawl_url': anchor.attr('href'),
        'is_compare': is_compare,
        'diff_found': diff_found});
    },

    _update_crawl_status: function() {
      $.ajax({
        dataType: "json",
        url: "screenshot/crawl_status.json",
        success: function(data) {
          var screenshots = data[0].screenshots;
          var running_status = data[0].worker.running_status;
          var first_status = data[0].worker.first_status;
          var running_type = data[0].worker.running_type;
          $('.crawl_btns .f_crawl_action').removeClass('running');
          $('.crawl_btns .f_crawl_action[data-type="'+running_type+'"]').addClass('running');
          $('.crawling a.last_img img').removeAttr("src");
          $('.crawling a.last_img img').removeAttr("alt");

          $('.f_sidenav_diffs span:last').text(data[0].counts.diff);
          $('.f_sidenav_controls span:last').text(data[0].counts.control);
          $('.f_sidenav_tests span:last').text(data[0].counts.test);
          $('.f_sidenav_compares span:last').text(data[0].counts.compare);

          for (var i=0; i < screenshots.length; i++) {
            Screenshots._add_crawl_url(screenshots[i]);
          }
          if (screenshots.length > 0) {
            var last = screenshots[screenshots.length-1];

            /* if the user isn't looking at other rows, then update the image */
            if (!Screenshots._clicked_urls_row) Screenshots._add_crawl_image(last);
          }

//          $('.cmd_status_msg').text('running: ' + running_status + ' first: ' + first_status);
          clearInterval(Screenshots._crawlStatusIntervalId);
          if (running_status === "working" || (first_status === "working" || first_status === "queued")) {
            Screenshots._crawlStatusIntervalId = setInterval(Screenshots._update_crawl_status, 3000);
            return;
          }
          $('.crawl_btns button').removeAttr("disabled");
          $('.crawl_btns .f_cancel').hide();
        }
      });
    },

    _add_crawl_url: function(screenshot) {
      if (screenshot.url === null) return;

      if ($('.crawling .urls li').length > 100) {
        $('.crawling .urls').empty();
      }

      var type = "test";
      var diff_class = "";
      if (screenshot.is_control === true) {
        type = "control";
      } else if (screenshot.is_compare === true) {
        diff_class = screenshot.diff_found === true ? " diff_found" : " no_diff_found";
        type = "diff";
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

      var existing_selector = '.crawling .urls li a[data-href="'+screenshot.url+'"][data-type="' + type + '"]';
      var existing = $(existing_selector);
      if (existing.length === 0) {
        $('.crawling .urls').prepend('<li><a data-type="' + type + '" data-href="' + screenshot.url + '"><i></i><span>' + type + ' : ' + screenshot.url + '</span></a></li>');
        existing = $(existing_selector);
      }
      if (typeof existing.attr('data-alt') === 'undefined' && src !== null) {
        existing.find('i').attr('class', icon_class);
        existing.attr('data-alt', file_name);
        existing.attr('data-src', src);
        Screenshots._add_crawl_image_with_src({
          'file_name': file_name,
          'src':src,
          'crawl_url': screenshot.url,
          'is_compare': screenshot.is_compare,
          'diff_found': screenshot.diff_found});
      }
    },

    _add_crawl_image: function(screenshot) {
      if (screenshot.image_file_name === null) return;
      Screenshots._add_crawl_image_with_src({
        'file_name': screenshot.image_file_name,
        'src':screenshot.displayable_image_path_full,
        'crawl_url': screenshot.url,
        'is_compare': screenshot.is_compare,
        'diff_found': screenshot.diff_found});
    },

    _add_crawl_image_with_src: function(params) {
      // don't replace the image with itself
      var existing_img = $('.crawling a.last_img img[src="'+params.src+'"]').length;
      if (existing_img > 0) return;

      if (params.is_compare) {
        if (params.diff_found === null || params.diff_found === false) {
          $('.crawling a.last_img .no_diff_found').show();
          $('.crawling a.last_img .diff_found').hide();
          $('.crawling a.last_img img').hide();
        } else {
          $('.crawling a.last_img .no_diff_found').hide();
          $('.crawling a.last_img .diff_found').show();
          $('.crawling a.last_img img').show();
        }
      } else {
        $('.crawling a.last_img .no_diff_found').hide();
        $('.crawling a.last_img .diff_found').hide();
        $('.crawling a.last_img img').show();
      }
      $('.crawling a.last_img').attr('href', params.src);
      $('.crawling a.last_img img').attr('alt', params.file_name);
      $('.crawling a.last_img img').attr('src', params.src);

      if (Screenshots._clicked_urls_row) return;
      $('.crawling .urls li').removeClass('active');
      $('.crawling .urls li a[data-href="'+params.crawl_url+'"]').parent('li').addClass('active');
    },

    _checkall_master_change: function() {
      $(".f_checkall_child").prop("checked", this.checked);
      Screenshots._disable_action_buttons();
    },
    _checkall_child_change: function() {
      $("#f_checkall").prop("checked", $(".f_checkall_child:checked").length == $(".f_checkall_child").length);
      Screenshots._disable_action_buttons();
    },
    _diffs_row_clicked: function(e) {
      if (e.target.type === 'checkbox') return;
      document.location = $(this).find('.diff_url').val();
    },

    _disable_action_buttons: function() {
      $(".f_actions button").attr("disabled", $(".f_checkall_child:checked").length === 0);
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
      $('.screenshots tbody tr').each(function() {
        var row = $(this);
        if (!row.find('td:first input[type=checkbox]:not(:checked)').length) {
          var diff_id = row.find('input.f_id').first().val();
          ids_array.push(diff_id);
        }
      });
      return ids_array.join(",");
    }

  };
}

$(function() {
  Screenshots._init();
});
