import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getAuthUser } from "@/lib/auth";

export async function PATCH(req: Request, { params }: { params: Promise<{ id: string }> }) {
  const decoded = await getAuthUser();
  if (!decoded) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  try {
    const task = await prisma.task.findUnique({ where: { id } });

    if (!task || task.userId !== decoded.userId) {
      return NextResponse.json({ error: "Task not found" }, { status: 404 });
    }

    const newStatus = task.status === "completed" ? "pending" : "completed";
    const updatedTask = await prisma.task.update({
      where: { id },
      data: { status: newStatus }
    });

    return NextResponse.json(updatedTask);
  } catch (error) {
    return NextResponse.json({ error: "Internal server error" }, { status: 500 });
  }
}
