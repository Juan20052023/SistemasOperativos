
# Define el nombre del archivo en donde se guardaran los datos de monitoreo
OUTPUT="monitoring_log.txt"
#Agrega una cabecera de columnas al archivo, que sirven para  identificar los datos  en cada columna
echo "Tiempo(s) %Total_CPU_Libre %Memoria_Libre %Disco_Libre" > $OUTPUT

# Generar funcion par  obtener el porcentaje del cpu
#Ejecuta el comando top  en modo  batch con solo una atulizacion de n1 , y de filtrar la linea  que contiene la infromación del cpu utilizando grep

get_cpu_free() {
    # `top -bn1` ejecuta una sola instancia de top en modo por lotes
    #Utiliza awk para calcular el porcentaje de CPU libre restando el porcentaje de uso de CPU ($2) a 100%
    cpu_free=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $2}')
    echo $cpu_free
}

# Obtener porcentaje de memoria libre
get_mem_free() {
    # `free -m` obtiene información de memoria en MB
    mem_free=$(free -m | awk '/Mem:/ {printf "%.2f", $4/$2 * 100}')
    echo $mem_free
}

# Porcentaje del  disco libre
get_disk_free() {
    # `df -h /` obtiene el espacio en el sistema raíz
    disk_free=$(df -h / | awk '/\// {print $4}')
    echo $disk_free
}

# Monitoreo por 5 minutos (300 segundos) cada 60 segundos
for (( i=60; i<=300; i+=60 ))
do
    cpu_free=$(get_cpu_free)
    mem_free=$(get_mem_free)
    disk_free=$(get_disk_free)
    echo "$i $cpu_free $mem_free $disk_free" >> $OUTPUT
    sleep 60
done
