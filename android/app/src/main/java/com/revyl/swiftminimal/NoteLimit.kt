package com.revyl.swiftminimal

object NoteLimit {
    const val CHARACTER_LIMIT = 60

    fun clamp(note: String): String = note.take(CHARACTER_LIMIT)

    fun counterLabel(note: String): String = "${note.length}/$CHARACTER_LIMIT characters"
}
