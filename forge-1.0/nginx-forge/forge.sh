export HOSTNAME=`cat /etc/hostname`
cat > $WEBROOT/index.php <<EOF
<!DOCTYPE html>

<html lang="fr">
<head>
	<meta charset="UTF-8">
	<title> Forge ${HOSTNAME}</title>
	<style>
	@import url('style.css');
	</style>
</head>

<body>

<div id="illustration">
<pre style="color:darkblue;" >
                           ##         .                  
                    ## ## ##        ==                   
                 ## ## ## ## ##    ===                   
              /""""""""""""""""\___/ ===                 
         ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~          
              \______ o          _,/                     
               \      \       _,'                        
                ''--.._\..--''                           
</pre>
</div>








<h1><?php print("<center> Portail d'acces a la forge: Forge ${HOSTNAME} </center>"); ?> </h1>
<p> <?php print("<center> Voici la liste des outils de la forge </center>"); ?> </p>

<div class="button">
<div id="gitlab"><a href="http://${HOSTNAME}:10089/">Gitlab</a> </div>
<div id="redmine"><a href="http://${HOSTNAME}:10090/">Redmine</a> </div>
<div id="jenkins"><a href="http://${HOSTNAME}:10091/">Jenkins</a> </div>
<div id="doku" ><a href="http://${HOSTNAME}:10092/">Dokuwiki</a> </div>

</div>



</body>
</html>
EOF

