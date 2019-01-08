<?php
$contents = file_get_contents('php://input');
$json_data = json_decode($contents);
$result = strcmp($json_data->event_name,'project_create');
if($result == 0){
	putenv("IDPRO=$json_data->project_id");
	putenv("NAMEPRO=$json_data->name");
	putenv("PROPATH=$json_data->path_with_namespace");
	$DESCRIPTIONN = system("psql -h postgresql -p 5432 -d gitlabhq_production -c \"SELECT description FROM projects WHERE name = '$json_data->name'\" | head -n -2 | tail -n +3");
	putenv("DESCRIPTION=$DESCRIPTIONN");
	system("envsubst < redmine.tpl.xml > redmine.xml");
	system("envsubst < dokuwiki.tpl.json > dokuwiki.json");
	system("./redmine.sh");
	system("./jenkins.sh");
	system("./dokuwiki.sh");
}
?>
