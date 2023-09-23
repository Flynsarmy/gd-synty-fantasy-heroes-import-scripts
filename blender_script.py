import bpy

# https://discord.com/channels/502587764299006004/1103191808667824129
# LegLeft_Male_* and LegRight_Male_* are reversed. It's a known issue
# that won't get fixed so let's fix them here.
for obj in bpy.context.selected_objects[0].children:
    if obj.name.startswith('Chr_LegLeft_Male_'):
        obj.name = 'Fixed' + obj.name.replace('LegLeft', 'LegRight')
    elif obj.name.startswith('Chr_LegRight_Male_'):
        obj.name = 'Fixed' + obj.name.replace('LegRight', 'LegLeft')

# Now go through and remove the 'Fixed' prefixes we added above
for obj in bpy.context.selected_objects[0].children:
    if obj.name.startswith('Fixed'):
        obj.name = obj.name[5:]

# Rename Meshes to be the same as their parent MeshObjects
for obj in bpy.context.selected_objects[0].children:
  if obj.type == 'MESH':
    obj.data.name = obj.name[4:]