class Villano {
  const ejercito = []     // el ejercito de minions!!
  var ciudadEnLaQueVive   // vive en una ciudad

  // 1.a) nuevoMinion Permite a un villano crear e incorporar nuevos minions, inicialmente amarillos, con 5 bananas y un rayo congelante de potencia 10.
  method nuevoMinon(){
    ejercito.add(new Minion(estado = amarillo, cantidadBananas = 5, armas = (new Arma(nombre = "rayoCongelante", potencia = 10))))
  }

  method planificarMaldad(maldad) {
    maldad.realizar(ejercito, ciudadEnLaQueVive)  // me conviene delegarlo a la maldad porque esta tiene muchos atributos
  }                                               // necesito el ejercito del villano, y la ciudad

  // 3. a) Obtener el minion más útil de un villano, que es el que participó en más maldades
  method minionMasUtil() = ejercito.max({minion => minion.maldadesRealizadas()})

}

class Minion {
  var estado
  var property cantidadBananas
  const armas = []  // llevan armas
  var property maldadesRealizadas = 0 

  // 1.e) esPeligroso Devuelve si un minion es peligroso.
  method esPeligroso() = estado.esPeligroso(self) // le paso la pelota al estado..
  
  method cambiarEstado(nuevo) { estado = nuevo }
  
  method alocarse(){
    self.cambiarEstado(violeta)   // estado = violeta
  }

  method tranquilizarse(){
    self.cambiarEstado(amarillo)  // estado = amarillo
  }

  // 1.c) alimentar Darle a un minion una cierta cantidad de bananas adicionales.
  method alimentar(cantidadAdicional) {
    cantidadBananas += cantidadAdicional
  }

  method perderUnaBanana(){
    cantidadBananas -= 1
  }

  method perderTodasLasArmas(){ armas.clear() }
  method cantidadArmas() = armas.size() 
  method tieneArma(arma) = armas.contains(arma)
  method armaMasPotente() = armas.max({arma => arma.potencia()})
  
  // 1.b) otorgarArma Se le otorga al minion un arma en particular, que se agrega a las anteriores.
  method otorgarArma(nuevaArma) {armas.add(nuevaArma)}

  // Definir lo que sea necesario para hacer que un minion tome el suero mutante y suceda lo que tiene que suceder.
  method absorberSueroMutante(){
    estado.tomarSueroMutante(self)   
  }

  // 1.d) nivelDeConcentracion Devuelve el nivel de concentración de un minion.
  method nivelDeConcentracion() = estado.nivelDeConcetracion(self)

  method contabilizarMaldad(){
    maldadesRealizadas += 1
  }

}

object amarillo {
  method esPeligroso(minion) = minion.cantidadArmas() > 2

  method tomarSueroMutante(minion) {
    minion.alocarse()               // ya no son amarrillos
    minion.perderTodasLasArmas()    // pierden todas sus armas
    minion.perderUnaBanana()        // pierden una banana   
  } 

  method nivelDeConcentracion(minion) = minion.armaMasPotente().potencia() + minion.cantidadBananas()
}

object violeta {
  method esPeligroso(minion) = true // Se consideran siempre peligrosos

  method tomarSueroMutante(minion) {
    minion.tranquilizarse()          // vuelve a ser amarrillo
    minion.perderUnaBanana()         // pierden una banana
  }

  method nivelDeConcentracion(minion) = minion.cantidadBananas()
}

// ---------------------- ARMAS ---------------------------
class Arma {
  const nombre
  const property potencia
}

// -----------------------------------------------------------------
// ---------------------  MALDADES ---------------------------------
// -----------------------------------------------------------------
class Maldad {
var requerimientoAdicional
var nivelDeConcentracionNecesario
var premio
var cambioCiudad

// Los minions capacitados son aquellos que tienen el requerimiento Adicional que requiere la maldad y tienen el nivel de concentracion necesario de la maldad 
method minionsCapacitados(ejercito) = ejercito.filter({minion => self.minionCapacitado(minion)})

method minionCapacitado(minion) = requerimientoAdicional.estaCapacitado(minion) and minion.nivelDeConcentracion() >= nivelDeConcentracionNecesario

  method realizar(ejercito, ciudad) {
    if(self.minionsCapacitados(ejercito).isEmpty()){
      throw new DomainException(message="La maldad NO tiene ningun minion asignado (no tiene minion capacitados)")
    }
    // Buscar minion capacitados para hacer la maldad
    // Si NO hay minions capacitados, no provaca cambios en la ciudad (EXCEPCION)
    // Provocar cambios en la ciudad
    
    self.premiarMinions(ejercito)
    cambioCiudad.provarCambio(ciudad)
  }

  // Premio a los minions segun el premio que otorga realizar la maldad y le contabilizo la maldad
  method premiarMinions(ejercito) {
    ejercito.forEach({minion => premio.premiar(minion)})
    ejercito.forEach({minion => minion.contabilizarMaldad()})
  }
}

// -----------------------------------------------------------------
// ---------------------  MALDADES  --------------------------------
// -----------------------------------------------------------------

object congelar inherits Maldad(requerimientoAdicional = requerimientoCongelante, nivelDeConcentracionNecesario = 500, premio = premio10bananas, cambioCiudad = new CambioTemperatura(temperatura = 30)){  
}

// ---------------------  ROBOS  --------------------------------

class Robo inherits Maldad(cambioCiudad = RobarCiudad) {
  override method minionCapacitado(minion) = super(minion) and minion.esPeligroso()
}

class RobarPiramide inherits Robo(requerimientoAdicional = requerimientoNulo, nivelDeConcentracionNecesario = alturaPiramide / 2, premio = premio10bananas, cambioCiudad = new RobarCiudad(objetoARobar = "piramide"))
{
  const alturaPiramide
}

class RobarSueroMutante inherits Robo(requerimientoAdicional = requerimientoRoboSueroMutante, nivelDeConcentracionNecesario = 23, premio = premioConsumirSueroMutante, cambioCiudad = new RobarCiudad(objetoARobar = "sueroMutante")){}

class RobarLuna inherits Robo(requerimientoAdicional = requerimientoLuna, nivelDeConcentracionNecesario = true, premio = premioLuna, cambioCiudad = new RobarCiudad(objetoARobar = "luna")){}
// -----------------------------------------------------------------
// ---------------------  CAMBIOS PROVOCADOS EN EN LA CIUDAD  ------
// -----------------------------------------------------------------

class CambioTemperatura {
  const temperatura
  
  method provocarCambio(ciudad) {
    ciudad.disminuirTemperatura(temperatura)
  }
}

class RobarCiudad {
  const objetoARobar

  method provocarCambio(ciudad) {
    ciudad.robarObjeto(objetoARobar)
  }
}

// -----------------------------------------------------------------
// ---------------------  REQUERIMIENTOS ---------------------------
// -----------------------------------------------------------------
class RequerimientoArmas {
  const armaRequerida

  method estaCapacitado(minion) = minion.tieneArma(armaRequerida) 
}

const requerimientoCongelante = new RequerimientoArmas(armaRequerida = "rayoCongelante")
const requerimientoLuna = new RequerimientoArmas(armaRequerida = "rayoEncogedor")

object requerimientoNulo {
  method estaCapacitado(minion) = true
}

class RequerimientoAlimentacion {
  const alimentacionNecesaria

  method estaCapacitado(minion) = minion.cantidadBananas() >= alimentacionNecesaria
}

const requerimientoRoboSueroMutante = new RequerimientoAlimentacion(alimentacionNecesaria = 100)

// -----------------------------------------------------------------
// ---------------------  CIUDADES  ---------------------------------
// -----------------------------------------------------------------
class Ciudad {
  var temperatura
  const posesiones = [] // son robadas cuando se realiza un Robo

  method disminuirTemperatura(temp) {
    temperatura = temperatura - temp
  }

  method robarObjeto(objeto) {
    posesiones.remove(objeto)
  }

} 


// -----------------------------------------------------------------
// ---------------------  PREMIOS  ---------------------------------
// -----------------------------------------------------------------
object premio10bananas {
  method premiar(minion) {
    minion.alimentar(10)
  }
}

object premioConsumirSueroMutante {
  method premiar(minion) {
    minion.absorberSueroMutante()
  }
}

class PremioOtorgarArma {
  const arma
  
  method premiar(minion) {
    minion.otorgarArma(arma)
  }
}

const premioLuna = new PremioOtorgarArma(arma = new Arma(nombre = "rayoCongelante", potencia = 10))


// PUNTO 4

/*
a) ¿Qué pasaría si los minions pudieran ser de otro color, de manera que, por ejemplo, 
los minions violetas se transforman en verdes al tomar el suero mutante, y éstos en amarillos, 
y además siendo verdes hacen cosas diferentes? Indicar en el diagrama de clases cómo 
se modificaría la solución anterior para incorporar esta nueva situación, 
implementar los métodos necesarios (inventar el nuevo comportamiento) y justificar conceptualmente.
*/

// Esto simplemente se puede hacer agregando un object verde como un nuevo estado de los minion y 
// luego definir su comportamiento. Hay que asegurarse que esta nuevo color entiende los mismos 
// mensajes que los demas estados, para asi seguir respetando la idea de polimorfismo (composicion). 
// Ademas habria que modificar el tema del cambio de estados cuando toman el suero mutante para cumplir
// con los nuevos requerimientos

/*
b) ¿Y si se estableciera que una vez que un minion amarillo pasa a violeta, es irreversible, 
y ya no puede volver a cambiar, por más suero mutante que tome?
*/

// Simplemente habria que modificar el metodo de tomarSueroMutante() dentro del violeta, sacando 
// la moficacion del estado del minion. En mi caso seria eliminado la llamada al metodo tranquilizarse() 

