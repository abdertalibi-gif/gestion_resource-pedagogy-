import type { dbStore } from '../data/store.js';

export type EnrichedUtilisateur = NonNullable<ReturnType<typeof dbStore.findUserById>>;
export type EnrichedModule = NonNullable<ReturnType<typeof dbStore.findModuleById>>;
export type EnrichedRessource = NonNullable<ReturnType<typeof dbStore.findRessourceById>>;
export type EnrichedDevoir = NonNullable<ReturnType<typeof dbStore.findDevoirById>>;
export type EnrichedSoumission = NonNullable<ReturnType<typeof dbStore.findSoumissionById>>;
