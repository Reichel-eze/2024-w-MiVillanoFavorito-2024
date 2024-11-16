class Villano {
  const ejercito = [] // el ejercito de minions!!
  var ciudadEnLaQueVive

  // 1.a) nuevoMinion Permite a un villano crear e incorporar nuevos minions, inicialmente amarillos, con 5 bananas y un rayo congelante de potencia 10.
  method nuevoMinon(){
    ejercito.add(new Minion(estado = amarillo, cantidadBananas = 5, armas = (new Arma(nombre = "rayoCongelante", potencia = 10))))
  }

  method planificarMaldad(maldad) {
    maldad.realizar(ejercito, ciudadEnLaQueVive)
  } 



}

class Minion {
  var estado
  var property cantidadBananas
  const armas = []  // llevan armas 

  // 1.e) esPeligroso Devuelve si un minion es peligroso.
  method esPeligroso() = estado.esPeligroso(self) // le paso la pelota al estado..
  
  method cambiarEstado(nuevo) { estado = nuevo }

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
  method absorberDelSueroMutante(){
    estado.tomarSueroMutante(self)   
  }

  // 1.d) nivelDeConcentracion Devuelve el nivel de concentración de un minion.
  method nivelDeConcentracion() = estado.nivelDeConcetracion(self)

}

object amarillo {
  method esPeligroso(minion) = minion.cantidadArmas() > 2

  method tomarSueroMutante(minion) {
    minion.cambiarEstado(violeta)   // ya no son amarrillos
    minion.perderTodasLasArmas()    // pierden todas sus armas
    minion.perderUnaBanana()        // pierden una banana   
  } 

  method nivelDeConcentracion(minion) = minion.armaMasPotente().potencia() + minion.cantidadBananas()
}

object violeta {
  method esPeligroso(minion) = true // Se consideran siempre peligrosos

  method tomarSueroMutante(minion) {
    minion.cambiarEstado(amarillo)   // vuelve a ser amarrillo
    minion.perderUnaBanana()         // pierden una banana
  }

  method nivelDeConcentracion(minion) = minion.cantidadBananas()
}

class Arma {
  const nombre
  const property potencia
}

class Maldad {
var requerimientoAdicional
var nivelDeConcentracionNecesario
var premio

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
    ciudad.provocarCambios()
  }

  // Premio a los minions segun el premio que otorga realizar la maldad
  method premiarMinions(ejercito) {
    ejercito.forEach({minion => premio.premiar(minion)})
  }
}

object congelar inherits Maldad(requerimientoAdicional = requerimientoCongelante, nivelDeConcentracionNecesario = 500, premio = premio10bananas){


}



// -----------------------------------------------------------------
// ---------------------  REQUERIMIENTOS ---------------------------
// -----------------------------------------------------------------
class RequerimientoArmas {
  const armaRequerida

  method estaCapacitado(minion) = minion.tieneArma(armaRequerida) 
}

const requerimientoCongelante = new RequerimientoArmas(armaRequerida = "rayoCongelante")


// -----------------------------------------------------------------
// ---------------------  CIUDADES  ---------------------------------
// -----------------------------------------------------------------
class Ciudad {
  var temperatura
  const posesiones = [] // son robadas cuando se realiza un Robo

  method provocarCambios(){

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


