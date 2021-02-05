<template>
  <v-container justify="center">
      <v-col  cols="1" md="1">
        <v-btn class="ma-2" tile color="indigo" dark>Envoyer</v-btn>
    </v-col>
  </v-container>
</template>


<script>
export default {
  methods: {
    sendtobot(){
      axios.post('https://api.com/v1/user', this.form)
                  .then(function( response ){
                    
                  }.bind(this));
    }
  }
}
</script>