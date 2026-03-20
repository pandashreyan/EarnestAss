import { headers } from "next/headers";
import { verifyAccessToken } from "./jwt";

export async function getAuthUser() {
  const headersList = await headers();
  const authHeader = headersList.get('authorization');
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return null;

  return verifyAccessToken(token);
}
