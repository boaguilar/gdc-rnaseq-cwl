#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_db)
        writable: true
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-qcmetrics-tool:b64e0be545e2a50a1978f34aab2ca3e3698fa7fa
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input) + sum_file_array_size([inputs.input_db, inputs.bam]))
    outdirMin: $(sum_file_array_size(inputs.input) + sum_file_array_size([inputs.input_db, inputs.bam]))

class: CommandLineTool

inputs:
  input: 
    type:
      type: array
      items: File 
      inputBinding:
        prefix: -i 

  bam: 
    type: File
    inputBinding:
      prefix: --bam

  job_uuid: 
    type: string
    inputBinding:
      prefix: -j

  input_db:
    type: File
    inputBinding:
      prefix: --output
      valueFrom: $(self.basename)

  export_format:
    type: string?
    default: "sqlite"
    inputBinding:
      prefix: --export_format

outputs:
  db: 
    type: File
    outputBinding:
      glob: $(inputs.input_db.basename)

baseCommand:
  - bio-qcmetrics-tool 
  - export
  - samtoolsidxstats 