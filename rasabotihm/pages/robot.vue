<template>
    <v-container>
        <v-row>
            <v-select
                class="col-md-4"
                ref="ttype"
                v-model="ttype"
                :rules="[() => !!ttype || 'This field is required']"
                :items="ttypes"
                label="Type d'élément"
                placeholder="Select..."
                required
                v-on:change="changeTTypes"
            >
            </v-select>
            <v-select
                class="col-md-4"
                ref="intentkey"
                v-model="intentkey"
                :rules="[() => !!intentkey || 'This field is required']"
                :items="intentkeys"
                label="Nom de l'élément"
                placeholder="Select..."
                required
                v-on:change="changeIntentKey"
            >
            </v-select>
            <v-spacer></v-spacer>
            <v-btn
                class="col-md-2 my-4"
                justify="center"
                align="center"
                color="blue darken-1"
                text
                @click="newintent"
                >
                AJouter un élément
            </v-btn>
        </v-row>
        <v-dialog
            v-model="dialog"
            max-width="500px"
        >
            <v-card>
            <v-card-title>
                <span class="headline">Ajouter un élément</span>
            </v-card-title>

            <v-card-text>
                <v-container>
                <v-row>
                    <v-col
                    cols="12"
                    sm="3"
                    md="3"
                    >
                    <v-select
                        :items="ttypes"
                        v-model="ttype"
                        label="Ttype"
                    ></v-select>
                    </v-col>
                    <v-col
                    cols="12"
                    sm="8"
                    md="8"
                    >
                    <v-text-field
                        v-model="intentkey"
                        label="Intent"
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
        <v-row>
            <KeyIntentText ref="myawesometable"
                v-bind:intentkey="this.intentkey"
                v-bind:ttype="this.ttype"
            ></KeyIntentText>
        </v-row>
    </v-container>
</template>

<script>

import axios from 'axios'
import KeyIntentText from "./keyintenttext.vue"

export default {
    components: {
        KeyIntentText
    },
    data: () => ({
        dialog: false,
        ttype: "",
        ttypes: ["intent", "synonym", "lookup"],
        intentkey: "",
        intentkeys: []
    }),
    methods: {
        changeTTypes(){
            
            const headers = {"Access-Control-Allow-Origin": "*"};
            const that = this;
            axios.get(`http://51.91.10.250:11000/texts/${this.ttype}`, {headers}
            
            ).then(function(response){
                that.intentkeys = response["data"][that.ttype]
            })
            .catch(function(err) {
                console.log(err);
            });
            
        },
        changeIntentKey(){
            this.$refs.myawesometable.initialize(this.ttype, this.intentkey, this.changeTTypes);
        },
        filterOnlyCapsText (value, search, item) {
            return value != null &&
                search != null &&
                typeof value === 'string' &&
                value.toString().toLocaleUpperCase().indexOf(search) !== -1
        },

        newintent(){
            this.dialog = true
        },
        close () {
            this.dialog = false;
        },
        save () {

            const that = this;
            const headers = {"Access-Control-Allow-Origin": "*"};
            axios.post(`http://51.91.10.250:11000/nlu/${this.ttype}/${this.intentkey}`, {headers}
            
            ).then(function(response){
                that.intentkey = response["data"][that.ttype];
                that.intentkeys.push(that.intentkey);
                that.$refs.myawesometable.initialize(that.ttype, that.intentkey, that.changeTTypes);
            })
            .catch(function(err) {
                console.log(err);
            });
            this.close()
        },

    }
}
</script>
