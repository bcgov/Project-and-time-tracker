<template>
  <v-layout column py-2>
    <v-layout>
      <v-flex md6>
        <div class="body-1">Project Name:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.projectName }}</div>
      </v-flex>
    </v-layout>
    <v-layout>
      <v-flex md6>
        <div class="body-1">Desired Date of Completion:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.estimatedCompletionDate }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1">Project Sector:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.projectSector.projectSectorName }}</div>
      </v-flex>
    </v-layout>


    <v-layout>
      <v-flex md6>
        <div class="body-1">Contract Amount:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.estimatedContractValue | withCommas }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1">MOU Amount:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.mouAmount }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1">Reprocurement?:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2" v-if="form.isReprocurement">Yes</div>
        <div class="body-2" v-if="!form.isReprocurement">No</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1" v-if="form.isReprocurement">Date original contract ends:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.dateOfReprocurement }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1" v-if="form.isReprocurement">
          What is the background from the previous contract?:
        </div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.previousContractBackground }}</div>
      </v-flex>
    </v-layout>

    <v-layout>
      <v-flex md6>
        <div class="body-1">What is the potential impact of this procurement project failing?:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.projectFailImpact }}</div>
      </v-flex>
    </v-layout>


    <v-layout>
      <v-flex md6>
        <div class="body-1">What does success look like for this procurement project?:</div>
      </v-flex>
      <v-flex md6 justify-center>
        <div class="body-2">{{ form.projectSuccess }}</div>
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
