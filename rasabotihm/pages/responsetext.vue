<template>
  <v-container v-if="!this.is_hidden">
    <v-container>
      <v-card
        color="#212121"
        dark
      > 
        <v-card-actions justify="center">
          <v-card-title class="headline" v-text="this.response_name"></v-card-title>
          <v-spacer></v-spacer>
          <v-icon class="mx-1" @click="editresponses()">mdi-pencil</v-icon>
          <v-icon class="mx-1" @click="deleteresponsesItem()">mdi-delete</v-icon>
        </v-card-actions>
      </v-card>
      <v-data-table
        :headers="headers"
        :items="this.texts"
        sort-by="id"
        class="elevation-1"
      >
        <template v-slot:top>
          <v-toolbar
            flat
          >
            <v-spacer></v-spacer>
            <v-dialog
              v-model="dialog"
              max-width="500px"
            >
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  color="primary"
                  dark
                  class="mb-2"
                  v-bind="attrs"
                  v-on="on"
                >
                  Ajouter un text
                </v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">{{ formTitle }}</span>
                </v-card-title>

                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col
                        cols="12"
                        sm="10"
                        md="10"
                      >
                        <v-text-field
                          v-model="editedItem.text"
                          label="Text"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="close"
                  >
                    Cancel
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="save"
                  >
                    Save
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
            <v-dialog
              v-model="dialogresponses"
              max-width="500px"
            >
              <v-card>
                <v-card-title>
                  <span class="headline">{{ formTitle }}</span>
                </v-card-title>

                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col
                        cols="12"
                        sm="10"
                        md="10"
                      >
                        <v-text-field
                          v-model="editedItem.text"
                          label="Text"
                        ></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                </v-card-text>

                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="close"
                  >
                    Cancel
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="saveresponses"
                  >
                    Save
                  </v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
            <v-dialog v-model="dialogDelete" max-width="510px">
              <v-card>
                <v-card-title class="headline">Are you sure you want to delete this Text?</v-card-title>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeDelete">Cancel</v-btn>
                  <v-btn color="blue darken-1" text @click="deleteItemConfirm">OK</v-btn>
                  <v-spacer></v-spacer>
                </v-card-actions>
              </v-card>
            </v-dialog>
            <v-dialog v-model="dialogresponsesDelete" max-width="510px">
              <v-card>
                <v-card-title class="headline">Are you sure you want to delete this Intent?</v-card-title>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeDelete">Cancel</v-btn>
                  <v-btn color="blue darken-1" text @click="deleteresponsesItemConfirm">OK</v-btn>
                  <v-spacer></v-spacer>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-toolbar>
        </template>
        <template v-slot:item.actions="{ item }">
          <v-icon
            small
            class="mr-1"
            @click="editItem(item)"
          >
            mdi-pencil
          </v-icon>
          <v-icon
            small
            @click="deleteItem(item)"
          >
            mdi-delete
          </v-icon>
        </template>
      </v-data-table>
    </v-container>
  </v-container>
</template>

<script>

import axios from 'axios'

  export default {
    data: () => ({
      is_hidden: true,
      callback_parent: null,
      response_name: null,
      texts: [],
      dialog: false,
      dialogresponses: false,
      dialogDelete: false,
      dialogresponsesDelete: false,
      headers: [
        {text: 'Id', value: 'id'},
        {text: 'Text', value: 'text' },
        {text: 'Actions', value: 'actions', sortable: false }
      ],
      editedIndex: -1,
      editedItem: {
        text: '',
        id: 0
      },
      defaultItem: {
        text: '',
        id: 0
      },
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      },
    },

    watch: {
      dialog (val) {
        val || this.close()
      },
      dialogDelete (val) {
        val || this.closeDelete()
      },
      
    },

    created () {
      this.initialize()
    },

    methods: {
      initialize (response_name=null, callback_parent) {

        if (!response_name){
          return;
        }

        this.callback_parent = callback_parent;
        this.is_hidden = false;
        this.response_name = response_name;
        this.dialogresponsesDelete = false;
        this.dialogDelete = false;
        this.dialog = false;
        this.dialogresponses = false;

        const headers = {"Access-Control-Allow-Origin": "*"};
        const that = this;
        axios.get(`http://51.91.10.250:11000/responses/text/${this.response_name}`, {headers}
        
        ).then(function(response){
            let id = 0;
            that.texts = [];
            response["data"][that.response_name].forEach(element => {
                that.texts.push({"id": id++, "text": element["text"]});
            });
        })
        .catch(function(err) {
            console.log(err);
        });
      },

      editItem (item) {
        this.editedIndex = this.texts.indexOf(item)
        this.editedItem = Object.assign({}, item)
        this.dialog = true
      },
      editresponses(){
        this.editedItem = {"text": this.response_name};
        this.dialogresponses = true
      },

      deleteItem (item) {
        this.editedIndex = this.texts.findIndex((x) => item.text === x.text);
        this.editedItem = Object.assign({}, item);
        this.dialogDelete = true;
      },
      deleteresponsesItem (item) {
        this.editedItem = Object.assign({}, item);
        this.dialogresponsesDelete = true;
      },

      deleteItemConfirm () {
        var that = this; 
        const headers = {"Content-Type": "application/json", "Access-Control-Allow-Origin": "*"};
        const data = {"text": this.texts[this.editedIndex].text };

        axios.delete(`http://51.91.10.250:11000/responses/text/${this.response_name}`, {
            headers: headers,
            data: data
          }
          ).then(function(response){
            that.texts.splice(that.editedIndex);
          })

        this.closeDelete()
      },

      close () {
        this.dialog = false;
        this.dialogresponses = false;
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        })
      },

      closeDelete () {
        this.dialogDelete = false
        this.dialogresponsesDelete = false;
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        })
      },

      save () {

        if (this.editedIndex > -1) {
            var that = this; 
            var editedIndex = this.editedIndex;
            const headers = {"Access-Control-Allow-Origin": "*"};
            const data = {"text":  this.texts[editedIndex].text, "new_text": this.editedItem.text};

            axios.put(`http://51.91.10.250:11000/responses/text/${this.response_name}`, 
            data,
            {headers}
            
            ).then(function(response){
                that.texts[editedIndex].text = response["data"][that.response_name]['new_text'];
            })
            
        } else {
            var that = this; 
            const headers = {"Access-Control-Allow-Origin": "*"};
            const data = {"text": this.editedItem.text};

            axios.post(`http://51.91.10.250:11000/responses/text/${this.response_name}`, 
            data,
            {headers}
            
            ).then(function(response){
                that.texts.push({"id": that.texts.length, "text": response["data"][that.response_name]});
            })
        }


        this.close()
      },


      saveresponses(){
        var that = this; 
        const headers = {"Access-Control-Allow-Origin": "*"};
        const data = {"new_response": this.editedItem.text};

        axios.put(`http://51.91.10.250:11000/responses/${this.response_name}`, 
            data,
            {headers}
        
        ).then(function(response){
          that.response_name = response['data']["response"];
          that.callback_parent();
        })

        this.close()
      },

      deleteresponsesItemConfirm(){
        var that = this; 
        const headers = {"Access-Control-Allow-Origin": "*"};

        axios.delete(`http://51.91.10.250:11000/responses/${this.response_name}`, 
        { headers: headers }
        
        ).then(function(response){
            that.is_hidden = true;
            that.callback_parent();
        })
        
        this.closeDelete()
      }
    },
  }
</script>