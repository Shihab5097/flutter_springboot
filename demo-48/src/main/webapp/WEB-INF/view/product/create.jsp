<jsp:include page="/WEB-INF/view/common/header.jsp" />

<form id="productForm">
	Name<input type="text" name="name" id="name" /><br /> Quantity<input
		type="text" name="quantity" id="quantity" /><br /> Price<input
		type="text" name="price" id="price" /><br /> <input type="button"
		value="Save" id="btnSave" class="btn btn-success" />
</form>
<button id="btnShow" class="btn btn-info">Show</button>
<table id="tblShow">
	<thead>
	</thead>
	<tbody>
	</tbody>
</table>
<jsp:include page="/WEB-INF/view/common/footer.jsp" />
<script>
	$("#btnSave").on("click", function(e) {
		$.ajax({
			type : "POST",
			url : "/product/save",
			data : $("#productForm").serialize(),
			success : function(data, status) {
				$("#productForm").trigger('reset'); //reset the form
				$.alert({
					title : 'Saved!',
					content : 'Data Saved successfully!',
				});
			}

		});

	});

	$("#btnShow").on("click", function(e) {
	/*      $.ajax({
		 type: "GET",
		 url: "/product/view",
		 success: function(data, status){
		 console.log("Data: " + data + "\nStatus: " + status);
		 console.log(data.length);
		 }
		 });  */
		
		 $.get("/product/view", function(data, status) {
			console.log("Data: " + data + "\nStatus: " + status);
			console.log(data.length);
			$("#tblShow tbody").html("");
			$("#tblShow thead").html("");
			var html = "";
			var htmlHeader = "";
			htmlHeader += "<tr>";
			htmlHeader += "<th>ID</th>";
			htmlHeader += "<th>Name</th>";
			htmlHeader += "<th>Quantity</th>";
			htmlHeader += "<th>Price</th>";
			htmlHeader += "<th>Action</th>";
			htmlHeader += "</tr>";

			for (i = 0; i < data.length; i++) {
				html += "<tr>";
				html += "<td>" + data[i].id + "</td>";
				html += "<td>" + data[i].name + "</td>";
				html += "<td>" + data[i].quantity + "</td>";
				html += "<td>" + data[i].price + "</td>";
				html += "<td><button class='btn btn-primary'><a href='/product/edit/"+data[i].id+"'>Edit</a></button><button class='btn btn-danger'><a href='/product/delete/"+data[i].id+"'>Delete</a></button></td>";
				html += "</tr>";
			}
			$("#tblShow thead").html(htmlHeader);
			$("#tblShow tbody").html(html);
			$('#tblShow').DataTable({
				"paging" : true,
				"ordering" : true,
				"info" : true
			});
		});

	});
</script>