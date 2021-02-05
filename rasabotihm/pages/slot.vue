<template>
  <v-container>
    <v-container>
      <v-card
        color="#212121"
        dark
      > 
        <v-card-actions justify="center">
          <v-card-title class="headline" v-text="this.slot_name"></v-card-title>
        </v-card-actions>
      </v-card>
      <v-data-table
        :headers="this.headers"
        :items="this.slots"
        class="elevation-1"
      >
        <template v-slot:top>
          <v-toolbar
            flat
          >
            <v-spacer></v-spacer>
            <v-dialog
              v-model="dialog_editItem"
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
                  Ajouter une ligne
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
                        <div v-for="(element, id) in editedItem"
                          v-bind:key="id"
                        >
                          <v-text-field
                          v-model="element.value"
                          v-bind:label="element.name"
                          v-bind:value="element.value"
                          ></v-text-field>
                        </div>
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
      slot_name: null,
      slots: [],
      dialog_editItem: false,
      dialogDelete: false,
      headers: [],
      editedIndex: -1,
      editedItem: {},
      defaultItem: {},
    }),

    computed: {
      formTitle () {
        return this.editedIndex === -1 ? 'New Item' : 'Edit Item'
      },
    },

    watch: {
      dialog_editItem (val) {
        val || this.close()
      },
      dialogDelete (val) {
        val || this.closeDelete()
      },
      
    },

    created () {
    },

    methods: {
      initialize (slot_name, slots) {
        this.slot_name = slot_name;

        const headers = {"Access-Control-Allow-Origin": "*"};
        const that = this;
        axios.get(`http://51.91.10.250:11000/names/slots/${slot_name}`, {headers}
        
        ).then(function(response){

            let indexoftype = response["data"]["slots"].findIndex((x) => x.name === "type");
            delete response["data"]["slots"].splice(indexoftype, 1);

            that.defaultItem = response["data"]["slots"]
            that.defaultItem.reverse();
            that.defaultItem.push({"name": "name"});
            that.defaultItem.reverse();


            that.defaultItem.forEach(element => {
              that.headers.push({text: element.name, value: element.name});
              element["value"] = "";
            });

            that.headers.push({text: 'Actions', value: 'actions', sortable: false });
            
        });

        this.slots = slots;
      },

      editItem (item) {
        this.editedIndex = this.slots.indexOf(item);
        this.editedItem = this.defaultItem;
        
        this.editedItem.forEach(element => {
          if (item.hasOwnProperty(element.name)){
            element["value"] = item[element.name];
          }
        });
        console.log(this.editedItem);
        this.dialog_editItem = true;
      },

      deleteItem (item) {
        this.editedIndex = this.slots.findIndex((x) => item.name === x.name);
        this.editedItem = Object.assign({}, item);
        this.dialogDelete = true;
      },

      deleteItemConfirm () {
          var that = this; 
          var editedIndex = this.editedIndex;
          const headers = {"Access-Control-Allow-Origin": "*"};

          axios.delete(`http://51.91.10.250:11000/slots/${this.slots[editedIndex]["name"]}`, 
          {headers}
          
          ).then(function(response){
              that.slots.splice(that.editedIndex);
          });

        this.closeDelete();
      },

      close () {
        this.dialog_editItem = false;
        this.dialogintent = false;
        this.$nextTick(() => {
          this.editedItem = Object.assign({}, this.defaultItem)
          this.editedIndex = -1
        })
      },

      closeDelete () {
        this.dialogDelete = false
        this.dialogintentDelete = false;
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
            const data = {}
            this.editedItem.forEach(element => {
                data[element["name"]] = element["value"];
            });

            data["new_slot"] = data["name"];

            axios.put(`http://51.91.10.250:11000/slots/${this.slots[editedIndex]["name"]}`, 
            data,
            {headers}
            
            ).then(function(response){
                var response = response["data"][data["new_slot"]];
                Object.assign(that.slots[editedIndex], response);
                that.slots[editedIndex]["name"] = data["new_slot"];
            });
            
        } else {
            var that = this; 
            const headers = {"Access-Control-Allow-Origin": "*"};
            const data = {}
            this.editedItem.forEach(element => {
                data[element["name"]] = element["value"];
            });

            axios.post(`http://51.91.10.250:11000/slots/${data["name"]}`, 
            data,
            {headers}
            
            ).then(function(response){
                var response = response["data"][data["new_slot"]];
                that.slots.push(response);
            });
        }


        this.close()
      },

    },
  }
</script>