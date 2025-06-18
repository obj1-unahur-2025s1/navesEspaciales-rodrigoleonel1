
class Nave {
  var velocidad
  var direccion
  var combustible

  method initialize(){
    if(direccion > 10 || direccion < -10){
      throw new Exception(message = "direccion debe ser un valor entre -10 y 10, incluyendo los extremos")
    }
  }
  method acelerar(cuanto){
    velocidad = (velocidad + cuanto).min(100000)
  }
  method desacelerar(cuanto){
    velocidad = (velocidad -cuanto).max(0)
  }
  method velocidad()= velocidad
  method direccion() = direccion
  method irHaciaElSol(){direccion = 10}
  method escaparDelSol(){direccion = -10}
  method ponerseParaleloAlSol(){direccion = 0}
  method acercarseUnPocoAlSol(){direccion = (direccion+ 1).min(10)}
  method alejarseUnPocoDelSol(){direccion = (direccion- 1).max(-10)}

  method cargarCombustible(unaCantidad){combustible += unaCantidad}
  method descargarCombustible(unaCantidad){combustible -= unaCantidad}
  method combustible()= combustible

  method prepararViaje(){
    self.cargarCombustible(30000)
    self.acelerar(5000)
  }
  method estaTranquila() = combustible >= 4000 && velocidad <=12000
  method escapar()
  method avisar()
  method recibirAmenaza(){
    self.escapar()
    self.avisar()
    }
  method estaDeRelajo() = self.estaTranquila()
} 

class NaveBaliza inherits Nave {
  var baliza
  var cambioDeBaliza = false

  method initialize(){
    const validos = #{"rojo", "verde", "azul"}
    if(!validos.contains(baliza)){
      throw new Exception(message = "el color de la valiza debe ser un strig con alguno de los valores: rojo, verde o azul")
    }
  }
  method cambiarColorDeBaliza(unColor) {
    const validos = #{"rojo", "verde", "azul"}
    if(!validos.contains(unColor)){
      throw new Exception(message = "el color de la valiza debe ser un strig con alguno de los valores: rojo, verde o azul")
    }else{
      baliza = unColor
      cambioDeBaliza = true
    }
  }
  method baliza() = baliza

  override method prepararViaje(){
    super()
    self.cambiarColorDeBaliza("verde")
    self.ponerseParaleloAlSol()
  }
  override method estaTranquila() = super() && baliza != "rojo"
  override method escapar(){self.irHaciaElSol()}
  override method avisar(){self.cambiarColorDeBaliza("rojo")}
  override method estaDeRelajo() = super() && !cambioDeBaliza
}

class NaveDePasajeros inherits Nave {
  const cantPasajeros
  var comidas = 0
  var bebidas = 0
  var comidasServidas = 0

  method comidas() = comidas
  method bebidas() = bebidas
  
  method cargarComidas(unaCantidad){
    comidas += unaCantidad
  }
  method cargarBebidas(unaCantidad){
    bebidas += unaCantidad
  }
  method descargarComidas(unaCantidad){
    comidas -= unaCantidad
    comidasServidas += unaCantidad
  }
  method descargarBebidas(unaCantidad){
    bebidas -= unaCantidad
  }

  override method prepararViaje(){
    super()
    self.cargarComidas(4 * cantPasajeros)
    self.cargarBebidas(6 * cantPasajeros)
    self.acercarseUnPocoAlSol()
  }
  override method escapar(){velocidad = velocidad * 2}
  override method avisar(){
    self.descargarComidas(cantPasajeros)
    self.descargarBebidas(cantPasajeros * 2)
  }
  override method estaDeRelajo() = super() && comidasServidas < 50

}
class NaveHospital inherits NaveDePasajeros {
  var quirofanosPreparados
  method quirofanosPreparados()= quirofanosPreparados
  method prepararQuirofanos(){quirofanosPreparados = true}
  method desarmarQuirofanos(){quirofanosPreparados = false}
  override method estaTranquila() = super() && !quirofanosPreparados
  override method recibirAmenaza(){
    super()
    self.prepararQuirofanos()
  }
}

class NaveDeCombate inherits Nave {
  var estaInvisible = false
  var misilesDesplegados = false
  const mensajes = []

  method ponerseVisible(){estaInvisible = true}
  method ponerseInvisible(){estaInvisible = false}
  method estaInisible() = estaInvisible

  method desplegasMisiles(){misilesDesplegados = true}
  method replegarMisiles(){misilesDesplegados = false}
  method misilesDesplegados() = misilesDesplegados 

  method emitirMensaje(unMensaje){
    mensajes.add(unMensaje)
    return unMensaje
  }
  method mensajesEmitidos()= mensajes
  method primerMensajeEmitido()= mensajes.first()
  method ultimoMensajeEmitido()= mensajes.last()
  method esEscueta()= mensajes.all({m=> m.length() >= 30})
  method emitioMensaje(unMensaje) = mensajes.contains(unMensaje)

  override method prepararViaje() {
    super()
    self.acelerar(15000)
    self.ponerseVisible()
    self.replegarMisiles()
    self.emitioMensaje("Saliendo en misión")
  } 
  override method estaTranquila()= super() && !misilesDesplegados
  override method escapar() {
    self.acercarseUnPocoAlSol()
    self.acercarseUnPocoAlSol()
  }
  override method avisar(){self.emitirMensaje("Amenaza recibida")}
}
class NaveDeCombateSigilosa inherits NaveDeCombate {
  override method estaTranquila()= super() && !estaInvisible
  override method escapar(){
    super()
    self.desplegasMisiles()
    self.ponerseInvisible()
  }
}