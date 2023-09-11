(function () {
	let status = [];

	let renderStatus = function () {
		$('#status_list').html('');

		for (let i = 0; i < status.length; i++) {

			if (!status[i].visible) {
				continue;
			}

			let statusDiv = $(
				'<div class="status">' +
					'<div class="status_inner">' +
						'<div class="status_val"></div>' +
						'<div class="backgrounds"></div>' + 
						
					'</div>' +
				'</div>' 
				
				);

			statusDiv.find('.backgrounds')
				.css({
					'background-color': status[i].color,
				});

			statusDiv.find('.status_val')
				.css({
				
					'background-color': status[i].color,
					'width': (status[i].val / 10000) + '%',
				});

				// status[i].val 

			$('#status_list').append(statusDiv);
		}
	};

	
	window.onData = function (data) {
		if (data.update) {
			status.length = 0;

			for (let i = 0; i < data.status.length; i++) {
				status.push(data.status[i]);
			}

			renderStatus();
		}

		if (data.setDisplay) {
			$('#status_list').css({ '': data.display });
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', function (event) {
			onData(event.data);
		});
	};

})();