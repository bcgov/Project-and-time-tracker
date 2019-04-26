<template>
  <v-layout column py-2>
    <v-layout>
      <v-flex md4>
        <div class="body-1">Project Name:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.projectName}}</div>
      </v-flex>
    </v-layout>
    <v-layout>
      <v-flex md4>
        <div class="body-1">Desired Completion Date:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.estimatedCompletionDate}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Project Sector:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.projectSector.projectSectorName}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Commodity Code:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.commodityCode}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Estimated Value of Contract:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.estimatedContractValue}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">MOU Amount:</div>
      </v-flex>
      <v-flex md8 justify-center>
        <div class="body-2">{{form.mouAmount}}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md4>
        <div class="body-1">Project Description:</div>
      </v-flex>
      <v-flex md8 align-content-end="true">
        <div class="body-2">{{form.description}}</div>
      </v-flex>
    </v-layout>
  </v-layout>
</template>

<script>
import './intakebaseinfo.styl';
import ProjectSectorDto from '@/domain/models/ProjectSector.dto';
import ClientDto from '@/domain/models/Client.dto';

export default {
  props: {
    project: Object,
  },
  data() {
    const form = Object.assign({}, this.$props.project);
    const inputProjectSector = form.projectSector || null;
    if (!inputProjectSector) {
      form.projectSector = new ProjectSectorDto();
    }
    const inputClient = form.client || null;
    if (!inputClient) {
      form.client = new ClientDto();
    }

    return {
      // Initialize using props
      form: { ...form },
    };
  },
  watch: {
    project(value) {
      this.form = value;
      const inputProjectSector = this.form.projectSector || null;
      if (!inputProjectSector) {
        this.form.projectSector = new ProjectSectorDto();
      }
    },
  },
};
</script>
