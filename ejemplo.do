********************************************************************
** Estimación de Personas con Discapacidad con educación superior **
*********************************************************************


// Establecemos la carpeta donde están ubicadas nuestras bases originales y la carpeta donde se guardaran las nuevas bases de datos.

gl rutaup "C:\Users\LENOVO\Documents\Bases_Enaho"
gl rutasave "C:\Users\LENOVO\Documents\Resultados"


// Usamos el módulo de educación de la Encuesta Nacional de Hogares del 2023 para obtener la información del nivel educativo alcanzado por la persona. 

use "$rutaup\enaho01a-2023-300.dta", clear

// Generamos una variable de indentificación único a partir del conglomerado, vivienda, hogar y código de la persona

gen id=conglome+vivienda+hogar+codperso

// Agrupamos la variable p301a para obtener dos grupos: personas que cuentan con educación superior completa y las que nos

recode p301a (1/6 7 9 12=1 "sin eduación superior")(8 10 11=2 "con educación superior"), gen(superior)

// Nos quedamos solamente con la variable de identificación única (id) y el la variable de educación superior 

keep id superior 

save "$rutasave\base_educ_sup.dta"

// Usamos el modulo de salud de la ENAHO para identificar a las Personas con Discapacidad. Se toma como Persona con Discapacidad a las personas que respondieron con un sí en alguna de las preguntas que corresponden a limitaciones físicas, mentales, visuales, auditivas y verbales

use "$rutaup\enaho01a-2023-400.dta", clear

gen discapacidad=1 if p401h1==1
replace discapacidad=1 if p401h2==1
replace discapacidad=1 if p401h3==1
replace discapacidad=1 if p401h4==1
replace discapacidad=1 if p401h6==1

// Asignamos las etiquetas a los valores de la variable discapacidad 

replace discapacidad = 0 if missing(discapacidad) 
label define discapacidad 1 "Con discapacidad" 0 "Sin discapacidad"
label values discapacidad discapacidad   


// Generamos una variable de indentificación único a partir del conglomerado, vivienda, hogar y código de la persona

gen id=conglome+vivienda+hogar+codperso

// Acoplamos la base con la información de educación superio de la persona a la base que estamos usando como llave la variable id 

merge 1:1 id using "$rutasave\base_educ_sup.dta"

// Por último, estimamos con el factor de expansión la cantidad de personas con discapacidad que tienen eduación superior 


tab discapacidad superior [iw=factor07]

** Obtenemos que en el año 2023, 136 313 personas con discapacidad tuvieron educación superior. 


