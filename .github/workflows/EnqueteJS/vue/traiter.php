<?= $helpers->card_header("4", "light", "dark", "h1", "Résultat de l'enquête"); ?>

<div class="container mt-5">
	<div class="row d-flex justify-content-center">
		<div class="col-12">
			<div class="card" style="background-color: #F5F5F5!important;">
				<div class="card-body">
					<canvas id="line-chart" width="800" height="450"></canvas>
					<script type="text/javascript">
						new Chart(document.getElementById("line-chart"), {
							type: 'line',
							data: {
								// Affichage des ages
								// labels: [<?php for ($i=1; $i<101; $i++) {echo $i.",";} ?>],
								labels: <?= $label; ?>,
								datasets: [{ 
									// Affichage des questions
									data: [<?php for ($i=1; $i<=$lesQuestions; $i++) {echo $i.",";} ?>],
									label: "Questions ",
									borderColor: "#3e95cd",
									fill: false
								}
							]
						},
						options: {
							title: {
								display: true,
								text: 'Statistique des réponses en fonction des ages'
							}
						}
					});
					</script>
				</div>
			</div>
		</div>
	</div>
</div>
