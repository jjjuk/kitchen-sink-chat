import { writeFileSync } from 'node:fs'

const mapProtobufTypes = (
  root: protobuf.Root,
  o: any,
  p: string,
  types: Map<string, protobuf.Type>,
  enums: Map<string, protobuf.Enum>
) => {
  for (let k in o) {
    switch (k) {
      case 'nested':
        mapProtobufTypes(root, o[k], p, types, enums)
        break
      case 'fields':
        types.set(p, root.lookupType(p))
        break
      case 'values':
        enums.set(p, root.lookupEnum(p))
        break
      case 'oneofs':
      case 'reserved':
        break
      default:
        mapProtobufTypes(root, o[k], p.length ? p + `.${k}` : k, types, enums)
        break
    }
  }
}

export class ProtobufTypesMap<T extends string, E extends string> {
  private types = new Map<string, protobuf.Type>()
  private enums = new Map<string, protobuf.Enum>()

  public constructor(root: protobuf.Root) {
    mapProtobufTypes(root, root.toJSON(), '', this.types, this.enums)
  }

  public getType(name: T) {
    return this.types.get(name) as protobuf.Type
  }
  public getEnum(name: E) {
    return this.enums.get(name) as protobuf.Enum
  }

  public typegen(path: string, filename = 'protobuf.ts') {
    let text = `// prettier-ignore\nexport type ProtobufTypes =\n`
    text += Array.from(this.types)
      .map((a) => `\u0009| '${a[0]}'\n`)
      .join('')
    text += `// prettier-ignore\nexport type ProtobufEnums =\n`
    text += Array.from(this.enums)
      .map((a) => `\u0009| '${a[0]}'\n`)
      .join('')

    writeFileSync(`${path}/${filename}`, text)
  }
}
