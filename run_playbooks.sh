#!/bin/bash
# Definition der Inventory-Datei
INVENTORY="hosts.ini"

# Überprüfung, ob Inventory-Datei existiert
if [ ! -f "$INVENTORY" ]; then
  echo "Inventory-Datei $INVENTORY nicht gefunden!"
  exit 1
fi

# Playbooksliste
PLAYBOOKS=(
  #"keystone.yml" 
  #"glance.yml"
  #"horizon.yml"
  nova.yml
  #placement.yml
)

# Fehlerzähler
ERROR_COUNT=0

# Ausführung der Playbooks mit Ausgabe der Zeit
for PLAYBOOK in "${PLAYBOOKS[@]}"; do
  if [ ! -f "$PLAYBOOK" ]; then
    echo "Playbook $PLAYBOOK nicht gefunden!"
    ((ERROR_COUNT++))
    continue
  fi

  echo "Running playbook: $PLAYBOOK"
  START_TIME=$(date +%s)
  
  # Ausführen der Playbooks mit Ausgabe der Fehlermeldung
  if ! ansible-playbook -i "$INVENTORY" "$PLAYBOOK"; then
    echo "Error running playbook: $PLAYBOOK"
    ((ERROR_COUNT++))
    continue
  fi

  END_TIME=$(date +%s)
  DURATION=$((END_TIME - START_TIME))
  
  echo "Playbook $PLAYBOOK completed in $DURATION seconds."
done

if [ $ERROR_COUNT -eq 0 ]; then
  echo "All playbooks executed successfully."
else
  echo "There were $ERROR_COUNT errors during the execution."
  exit 1
fi
