#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-qcmetrics-tool:b06eec26aa9f9763c1a25bf2e5e15193e27973ba
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./util_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    ramMin: 1000
    tmpdirMin: $(sum_file_array_size(inputs.input) + file_size_multiplier(inputs.bam))
    outdirMin: $(sum_file_array_size(inputs.input) + file_size_multiplier(inputs.bam))

class: CommandLineTool

inputs:
  input: 
    type:
      type: array
      items: File 
      inputBinding:
        prefix: -i 

  job_uuid: 
    type: string
    inputBinding:
      prefix: -j

  bam: 
    type: File 
    inputBinding:
      prefix: --bam

  export_format:
    type: string?
    default: "sqlite"
    inputBinding:
      prefix: --export_format

outputs:
  db: 
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + '.rnaseq_metrics.db')

baseCommand:
  - bio-qcmetrics-tool 
  - export 
  - readgroup

arguments:
  - valueFrom: $(inputs.job_uuid + '.rnaseq_metrics.db')
    position: 0
    prefix: --output
