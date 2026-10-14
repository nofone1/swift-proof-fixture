export const NOTE_CHARACTER_LIMIT = 60;

export function clampNote(note: string): string {
  return note.slice(0, NOTE_CHARACTER_LIMIT);
}

export function noteCounterLabel(note: string): string {
  return `${note.length}/${NOTE_CHARACTER_LIMIT} characters`;
}
